import AVFoundation

/// Round-robin voice pool for pad triggers, one buffer per loaded pad, extracted once
/// at assignment time so triggering never touches disk. Full mixer/choke/ADSR is
/// Day 4 — this only has to prove distinct samples per pad play without stealing
/// each other's voices when multiple pads fire at once (multitouch, proven Day 1).
final class PadVoicePool: ObservableObject {
    private let engine = AVAudioEngine()
    private var nodes: [AVAudioPlayerNode] = []
    private var nextVoice = 0
    private let voiceCount = 8
    private var buffers: [Int: AVAudioPCMBuffer] = [:]

    init() {
        for _ in 0..<voiceCount {
            let node = AVAudioPlayerNode()
            engine.attach(node)
            engine.connect(node, to: engine.mainMixerNode, format: nil)
            nodes.append(node)
        }
        try? engine.start()
    }

    func loadPads(_ pads: [Pad]) {
        buffers.removeAll()
        for pad in pads {
            guard let slice = pad.slice, let buffer = Self.extractBuffer(slice: slice) else { continue }
            buffers[pad.index] = buffer
        }
    }

    func trigger(pad: Int) {
        guard let buffer = buffers[pad] else { return }
        if !engine.isRunning { try? engine.start() }
        let node = nodes[nextVoice]
        nextVoice = (nextVoice + 1) % voiceCount
        node.stop()
        node.scheduleBuffer(buffer, at: nil, options: .interrupts)
        node.play()
    }

    private static func extractBuffer(slice: Slice) -> AVAudioPCMBuffer? {
        guard let file = try? AVAudioFile(forReading: slice.sourceURL) else { return nil }
        let format = file.processingFormat
        let startFrame = AVAudioFramePosition(slice.startTime * format.sampleRate)
        let endFrame = AVAudioFramePosition(slice.endTime * format.sampleRate)
        let frameCount = AVAudioFrameCount(max(0, endFrame - startFrame))
        guard frameCount > 0 else { return nil }
        file.framePosition = startFrame
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        try? file.read(into: buffer, frameCount: frameCount)
        return buffer
    }
}
