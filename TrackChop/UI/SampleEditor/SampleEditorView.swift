import SwiftUI
import UniformTypeIdentifiers

struct SampleEditorView: View {
    @EnvironmentObject private var padBank: PadBank
    @EnvironmentObject private var voicePool: PadVoicePool
    @StateObject private var recorder = MicRecorder()
    @StateObject private var playback = FilePlaybackEngine()
    @State private var sample: AudioSample?
    @State private var isImporterPresented = false
    @State private var loadProgress: Double?
    @State private var errorMessage: String?
    @State private var accessedURL: URL?
    @State private var chopMarkers: [ChopMarker] = []

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
                    chopMarkers: $chopMarkers,
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
                        let playheadInRange = playback.playheadTime > sample.startMarker
                            && playback.playheadTime < sample.endMarker
                        let start = playheadInRange ? playback.playheadTime : sample.startMarker
                        playback.playRegion(start: start, end: sample.endMarker)
                    }
                }

                chopControls(sample)
                sliceList
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
        .onDisappear { stopAccessingCurrentURL() }
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
                    // Load the playback engine BEFORE releasing the security scope —
                    // AVAudioFile keeps reading from this URL on later Play taps.
                    do {
                        try playback.load(url: url)
                        stopAccessingCurrentURL()
                        accessedURL = accessed ? url : nil
                        sample = loaded
                        chopMarkers = []
                        playback.playheadTime = 0
                    } catch {
                        if accessed { url.stopAccessingSecurityScopedResource() }
                        errorMessage = "재생 엔진에 파일을 불러오지 못했습니다."
                    }
                    loadProgress = nil
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

    private func stopAccessingCurrentURL() {
        accessedURL?.stopAccessingSecurityScopedResource()
        accessedURL = nil
    }

    // MARK: - Chop / Slice

    private var slices: [Slice] {
        guard let sample else { return [] }
        let points = ([sample.startMarker] + chopMarkers.map(\.time) + [sample.endMarker]).sorted()
        var result: [Slice] = []
        for i in 0..<(points.count - 1) {
            let start = points[i]
            let end = points[i + 1]
            guard end - start > 0.01 else { continue }
            result.append(Slice(sourceURL: sample.url, startTime: start, endTime: end, name: "Slice \(result.count + 1)"))
        }
        return result
    }

    private func chopControls(_ sample: AudioSample) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Button("Add Marker") { addMarker(at: playback.playheadTime, sample: sample) }
                Button("Equal 4") { applyEqualSlice(4, sample: sample) }
                Button("Equal 8") { applyEqualSlice(8, sample: sample) }
                Button("Equal 16") { applyEqualSlice(16, sample: sample) }
                if !chopMarkers.isEmpty {
                    Button("Clear Markers") { chopMarkers = [] }
                }
            }
            if !chopMarkers.isEmpty {
                HStack(spacing: 6) {
                    ForEach(chopMarkers.sorted(by: { $0.time < $1.time })) { marker in
                        HStack(spacing: 4) {
                            Text(String(format: "%.2fs", marker.time))
                                .font(.system(.caption2, design: .monospaced))
                            Button {
                                chopMarkers.removeAll { $0.id == marker.id }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }

    private var sliceList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(slices.count) slice\(slices.count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(slices.enumerated()), id: \.element.id) { i, slice in
                        VStack(spacing: 4) {
                            Text("\(i + 1)").font(.system(.caption, design: .monospaced))
                            Button("▶") { playback.playRegion(start: slice.startTime, end: slice.endTime) }
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }

            Button("Assign \(min(slices.count, 16)) Slices to Pads") {
                let assigned = padBank.assign(slices: slices)
                voicePool.loadPads(assigned)
            }
            .disabled(slices.isEmpty)

            if slices.count > 16 {
                Text("16개 Pad까지만 배치됨 — 나머지 \(slices.count - 16)개는 제외됨")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
    }

    private func addMarker(at time: TimeInterval, sample: AudioSample) {
        let t = max(sample.startMarker, min(sample.endMarker, time))
        chopMarkers.append(ChopMarker(time: t))
    }

    private func applyEqualSlice(_ count: Int, sample: AudioSample) {
        let span = sample.endMarker - sample.startMarker
        guard span > 0 else { return }
        chopMarkers = (1..<count).map { i in
            ChopMarker(time: sample.startMarker + span * Double(i) / Double(count))
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
