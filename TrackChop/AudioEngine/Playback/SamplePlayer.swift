import AVFoundation

/// Day 1 spike: single-voice trigger to prove the input-to-sound path works.
/// Multi-voice polyphony, choke groups, and pad-level mixing are Day 4 scope.
final class SamplePlayer: ObservableObject {
    private let engine = AVAudioEngine()
    private let node = AVAudioPlayerNode()
    private var buffer: AVAudioPCMBuffer?

    init() {
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: nil)
        loadTestSound()
        try? engine.start()
    }

    private func loadTestSound() {
        let url = URL(fileURLWithPath: "/System/Library/Sounds/Tink.aiff")
        guard let file = try? AVAudioFile(forReading: url),
              let buf = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
        else { return }
        try? file.read(into: buf)
        buffer = buf
    }

    func trigger() {
        guard let buffer else { return }
        if !engine.isRunning {
            try? engine.start()
        }
        node.stop()
        node.scheduleBuffer(buffer, at: nil, options: .interrupts)
        node.play()
    }
}
