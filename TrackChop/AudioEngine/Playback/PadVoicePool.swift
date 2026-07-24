import AVFoundation

/// One dedicated voice per pad (not a shared round-robin pool): retriggering the
/// same pad cuts that pad's own previous hit (Mono default), while different pads
/// still overlap freely (multitouch, proven Day 1). Full Mono/Poly toggle,
/// choke groups, and ADSR are Day 4.
final class PadVoicePool: ObservableObject {
    private let engine = AVAudioEngine()
    private var nodes: [AVAudioPlayerNode] = []
    private var buffers: [Int: AVAudioPCMBuffer] = [:]

    init() {
        for _ in 1...16 {
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
        guard let buffer = buffers[pad], nodes.indices.contains(pad - 1) else { return }
        if !engine.isRunning { try? engine.start() }
        let node = nodes[pad - 1]
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
