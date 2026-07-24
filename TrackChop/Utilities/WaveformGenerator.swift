import AVFoundation

enum WaveformGeneratorError: Error {
    case unsupportedFile
}

/// Reads an audio file in chunks and downsamples to a fixed bucket count for waveform
/// rendering. Call from a background queue — call sites are responsible for that
/// (see SampleEditorView.importFile), since this does blocking file I/O.
enum WaveformGenerator {
    static let maxBuckets = 2000

    static func load(url: URL, onProgress: @escaping (Double) -> Void) throws -> AudioSample {
        guard let file = try? AVAudioFile(forReading: url) else {
            throw WaveformGeneratorError.unsupportedFile
        }
        let format = file.processingFormat
        let channelCount = Int(format.channelCount)
        guard channelCount > 0, file.length > 0 else {
            throw WaveformGeneratorError.unsupportedFile
        }
        let sampleRate = format.sampleRate
        let duration = Double(file.length) / sampleRate

        let bucketCount = min(maxBuckets, Int(file.length))
        let framesPerBucket = max(1, Int(file.length) / bucketCount)
        var peaks = [Float](repeating: 0, count: bucketCount * 2)

        let chunkFrames: AVAudioFrameCount = 65536
        guard let chunkBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: chunkFrames) else {
            throw WaveformGeneratorError.unsupportedFile
        }

        var bucketIndex = 0
        var samplesInBucket = 0
        var bucketMin: Float = 0
        var bucketMax: Float = 0
        var framesRead: AVAudioFramePosition = 0

        while framesRead < file.length {
            try file.read(into: chunkBuffer, frameCount: chunkFrames)
            let n = Int(chunkBuffer.frameLength)
            if n == 0 { break }
            guard let channelData = chunkBuffer.floatChannelData else { break }

            for i in 0..<n {
                var sample: Float = 0
                for c in 0..<channelCount {
                    sample += channelData[c][i]
                }
                sample /= Float(channelCount)
                bucketMin = min(bucketMin, sample)
                bucketMax = max(bucketMax, sample)
                samplesInBucket += 1
                if samplesInBucket >= framesPerBucket && bucketIndex < bucketCount - 1 {
                    peaks[bucketIndex * 2] = bucketMin
                    peaks[bucketIndex * 2 + 1] = bucketMax
                    bucketIndex += 1
                    samplesInBucket = 0
                    bucketMin = 0
                    bucketMax = 0
                }
            }
            framesRead += AVAudioFramePosition(n)
            onProgress(Double(framesRead) / Double(file.length))
        }

        if bucketIndex < bucketCount {
            peaks[bucketIndex * 2] = bucketMin
            peaks[bucketIndex * 2 + 1] = bucketMax
        }

        return AudioSample(
            url: url,
            displayName: url.lastPathComponent,
            duration: duration,
            sampleRate: sampleRate,
            channelCount: channelCount,
            peaks: peaks,
            startMarker: 0,
            endMarker: duration
        )
    }
}
