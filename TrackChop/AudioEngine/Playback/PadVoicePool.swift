import AVFoundation

/// One dedicated voice per pad (not a shared round-robin pool): retriggering the
/// same pad cuts that pad's own previous hit (Mono default), while different pads
/// still overlap freely (multitouch, proven Day 1).
final class PadVoicePool: ObservableObject {
    private let engine = AVAudioEngine()
    private var nodes: [AVAudioPlayerNode] = []
    private var pitchUnits: [AVAudioUnitVarispeed] = []
    private var buffers: [Int: AVAudioPCMBuffer] = [:]
    private var modes: [Int: PlaybackMode] = [:]
    private var chokeGroups: [Int: Int] = [:]

    init() {
        for _ in 1...16 {
            let node = AVAudioPlayerNode()
            let pitch = AVAudioUnitVarispeed()
            engine.attach(node)
            engine.attach(pitch)
            engine.connect(node, to: pitch, format: nil)
            engine.connect(pitch, to: engine.mainMixerNode, format: nil)
            nodes.append(node)
            pitchUnits.append(pitch)
        }
        try? engine.start()
    }

    /// Full reload: re-extracts each loaded pad's buffer from disk. Needed when
    /// slices change or `reverse` toggles — everything else is a plain node
    /// parameter, see `applyParameters`.
    func loadPads(_ pads: [Pad]) {
        buffers.removeAll()
        for pad in pads {
            guard let slice = pad.slice, var buffer = Self.extractBuffer(slice: slice) else { continue }
            if pad.reverse {
                buffer = Self.reversed(buffer)
            }
            buffers[pad.index] = buffer
        }
        applyParameters(pads)
    }

    /// Volume/pan/tune/mode/choke-group are live node parameters — no file I/O,
    /// safe to call on every slider tick in Program Edit.
    func applyParameters(_ pads: [Pad]) {
        modes.removeAll()
        chokeGroups.removeAll()
        for pad in pads {
            guard pad.isLoaded, nodes.indices.contains(pad.index - 1) else { continue }
            nodes[pad.index - 1].volume = Float(pad.volume)
            nodes[pad.index - 1].pan = Float(pad.pan)
            pitchUnits[pad.index - 1].rate = Float(pow(2.0, pad.tuneSemitones / 12.0))
            modes[pad.index] = pad.playbackMode
            if let group = pad.chokeGroup {
                chokeGroups[pad.index] = group
            }
        }
    }

    func trigger(pad: Int) {
        #if DEBUG
        let start = CFAbsoluteTimeGetCurrent()
        #endif
        guard let buffer = buffers[pad], nodes.indices.contains(pad - 1) else { return }
        if !engine.isRunning { try? engine.start() }

        if let group = chokeGroups[pad] {
            for (otherPad, otherGroup) in chokeGroups where otherGroup == group && otherPad != pad {
                nodes[otherPad - 1].stop()
            }
        }

        let node = nodes[pad - 1]
        node.stop()
        node.scheduleBuffer(buffer, at: nil, options: .interrupts)
        node.play()

        #if DEBUG
        // Dispatch-side proxy only (schedule+play call overhead), not true
        // tap-to-sound latency — that needs physical measurement, see plan.md Day 7.
        let ms = (CFAbsoluteTimeGetCurrent() - start) * 1000
        print(String(format: "[latency] pad %d dispatch %.2fms", pad, ms))
        #endif
    }

    func release(pad: Int) {
        guard modes[pad] == .hold, nodes.indices.contains(pad - 1) else { return }
        nodes[pad - 1].stop()
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

    private static func reversed(_ buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer {
        guard let data = buffer.floatChannelData,
              let copy = AVAudioPCMBuffer(pcmFormat: buffer.format, frameCapacity: buffer.frameCapacity),
              let copyData = copy.floatChannelData
        else { return buffer }
        copy.frameLength = buffer.frameLength
        let frameLength = Int(buffer.frameLength)
        let channelCount = Int(buffer.format.channelCount)
        for c in 0..<channelCount {
            for i in 0..<frameLength {
                copyData[c][i] = data[c][frameLength - 1 - i]
            }
        }
        return copy
    }
}
