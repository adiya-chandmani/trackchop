import AVFoundation

/// Plays a selected region [start, end) of an arbitrary audio file — the Sample Edit
/// preview path. Separate from SamplePlayer, which is the low-latency pad trigger path.
final class FilePlaybackEngine: ObservableObject {
    @Published var isPlaying = false
    @Published var playheadTime: TimeInterval = 0

    private let engine = AVAudioEngine()
    private let node = AVAudioPlayerNode()
    private var file: AVAudioFile?
    private var displayTimer: Timer?
    private var regionStart: TimeInterval = 0
    private var regionEnd: TimeInterval = 0
    private var playStartWallClock: TimeInterval = 0
    private var playToken = 0

    init() {
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: nil)
    }

    func load(url: URL) throws {
        file = try AVAudioFile(forReading: url)
    }

    func playRegion(start: TimeInterval, end: TimeInterval) {
        guard let file else { return }
        node.stop()
        let format = file.processingFormat
        let startFrame = AVAudioFramePosition(start * format.sampleRate)
        let endFrame = AVAudioFramePosition(end * format.sampleRate)
        let frameCount = AVAudioFrameCount(max(0, endFrame - startFrame))
        guard frameCount > 0 else { return }
        file.framePosition = startFrame
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        try? file.read(into: buffer, frameCount: frameCount)

        if !engine.isRunning { try? engine.start() }
        regionStart = start
        regionEnd = end
        playStartWallClock = Date().timeIntervalSinceReferenceDate
        playToken += 1
        let token = playToken
        // scheduleBuffer's completion handler fires async and can land after a
        // later playRegion()/stop() already moved on — the token guard drops
        // those stale callbacks instead of letting them kill live playback state.
        node.scheduleBuffer(buffer, at: nil, options: .interrupts) { [weak self] in
            DispatchQueue.main.async {
                guard let self, self.playToken == token else { return }
                self.isPlaying = false
                self.displayTimer?.invalidate()
            }
        }
        node.play()
        isPlaying = true
        startDisplayTimer()
    }

    func stop() {
        playToken += 1
        node.stop()
        isPlaying = false
        displayTimer?.invalidate()
    }

    private func startDisplayTimer() {
        displayTimer?.invalidate()
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            let elapsed = Date().timeIntervalSinceReferenceDate - self.playStartWallClock
            self.playheadTime = min(self.regionEnd, self.regionStart + elapsed)
        }
    }
}
