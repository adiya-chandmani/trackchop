import SwiftUI
import UniformTypeIdentifiers

struct SampleEditorView: View {
    @StateObject private var recorder = MicRecorder()
    @StateObject private var playback = FilePlaybackEngine()
    @State private var sample: AudioSample?
    @State private var isImporterPresented = false
    @State private var loadProgress: Double?
    @State private var errorMessage: String?

    private let importedTypes: [UTType] = [.wav, .aiff, .mp3, .mpeg4Audio]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.callout)
            }
            if let loadProgress {
                ProgressView(value: loadProgress).frame(maxWidth: 300)
            }

            if let sample {
                metadata(sample)
                WaveformView(
                    peaks: sample.peaks,
                    duration: sample.duration,
                    startMarker: startBinding,
                    endMarker: endBinding,
                    playheadTime: playback.playheadTime,
                    onSeek: { playback.playheadTime = $0 }
                )
                .frame(height: 160)
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Button(playback.isPlaying ? "Stop" : "Play Selection") {
                    if playback.isPlaying {
                        playback.stop()
                    } else {
                        playback.playRegion(start: sample.startMarker, end: sample.endMarker)
                    }
                }
            } else {
                Text("No sample loaded").foregroundStyle(.gray)
            }

            recordingControls
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: importedTypes) { result in
            switch result {
            case .success(let url):
                importFile(url)
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Sample Edit").font(.title2.bold()).foregroundStyle(.orange)
            Spacer()
            Button("Import Sample") { isImporterPresented = true }
        }
    }

    private func metadata(_ sample: AudioSample) -> some View {
        Text(String(format: "%@  •  %.1fs  •  %.0f Hz  •  %d ch",
                     sample.displayName, sample.duration, sample.sampleRate, sample.channelCount))
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.white.opacity(0.7))
    }

    private var startBinding: Binding<TimeInterval> {
        Binding(get: { sample?.startMarker ?? 0 }, set: { sample?.startMarker = $0 })
    }

    private var endBinding: Binding<TimeInterval> {
        Binding(get: { sample?.endMarker ?? 0 }, set: { sample?.endMarker = $0 })
    }

    private func importFile(_ url: URL) {
        errorMessage = nil
        loadProgress = 0
        let accessed = url.startAccessingSecurityScopedResource()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let loaded = try WaveformGenerator.load(url: url) { progress in
                    DispatchQueue.main.async { loadProgress = progress }
                }
                DispatchQueue.main.async {
                    if accessed { url.stopAccessingSecurityScopedResource() }
                    sample = loaded
                    loadProgress = nil
                    try? playback.load(url: url)
                }
            } catch {
                DispatchQueue.main.async {
                    if accessed { url.stopAccessingSecurityScopedResource() }
                    errorMessage = "지원하지 않거나 손상된 파일입니다."
                    loadProgress = nil
                }
            }
        }
    }

    private var recordingControls: some View {
        HStack(spacing: 12) {
            switch recorder.state {
            case .idle:
                Button("Record") { recorder.requestPermissionAndStart() }
            case .recording:
                Button("Pause") { recorder.pause() }
                Button("Stop") { finishRecording() }
            case .paused:
                Button("Resume") { recorder.resume() }
                Button("Stop") { finishRecording() }
            }
            if recorder.state != .idle {
                LevelMeterView(db: recorder.levelDb).frame(width: 120, height: 8)
                Text(String(format: "%.1fs", recorder.elapsed))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
            }
            if recorder.permissionDenied {
                Text("마이크 권한이 필요합니다").foregroundStyle(.red)
            }
        }
    }

    private func finishRecording() {
        guard let url = recorder.stop() else { return }
        importFile(url)
    }
}
