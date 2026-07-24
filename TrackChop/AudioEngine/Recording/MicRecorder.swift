import AVFoundation

/// Records from the system default input device. Explicit input-device selection
/// (PRD 11.3) is deferred — not needed to prove the record → waveform path in Day 2.
final class MicRecorder: NSObject, ObservableObject {
    enum State {
        case idle, recording, paused
    }

    @Published var state: State = .idle
    @Published var levelDb: Float = -160
    @Published var elapsed: TimeInterval = 0
    @Published var permissionDenied = false

    private var recorder: AVAudioRecorder?
    private var meterTimer: Timer?
    private(set) var recordingURL: URL?

    func requestPermissionAndStart() {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
            DispatchQueue.main.async {
                guard let self else { return }
                guard granted else {
                    self.permissionDenied = true
                    return
                }
                self.permissionDenied = false
                self.start()
            }
        }
    }

    func pause() {
        recorder?.pause()
        state = .paused
        meterTimer?.invalidate()
    }

    func resume() {
        recorder?.record()
        state = .recording
        startMeterTimer()
    }

    func stop() -> URL? {
        recorder?.stop()
        meterTimer?.invalidate()
        state = .idle
        return recordingURL
    }

    private func start() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("TrackChop/Recordings", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("Recording-\(Int(Date().timeIntervalSince1970)).caf")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
        ]
        guard let recorder = try? AVAudioRecorder(url: url, settings: settings) else { return }
        recorder.isMeteringEnabled = true
        recorder.record()
        self.recorder = recorder
        recordingURL = url
        state = .recording
        elapsed = 0
        startMeterTimer()
    }

    private func startMeterTimer() {
        meterTimer?.invalidate()
        meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self, let recorder = self.recorder else { return }
            recorder.updateMeters()
            self.levelDb = recorder.averagePower(forChannel: 0)
            self.elapsed = recorder.currentTime
        }
    }
}
