import SwiftUI

struct MainView: View {
    @EnvironmentObject private var padBank: PadBank
    @EnvironmentObject private var voicePool: PadVoicePool
    @State private var triggeredPads: Set<Int> = []
    @State private var touches: [TrackpadTouch] = []
    @FocusState private var isFocused: Bool

    // Bottom-to-top keyboard rows mirror the pad grid's bottom-to-top layout
    // (PRD 14 / common sampler convention).
    private let keyPadMap: [Character: Int] = [
        "z": 1, "x": 2, "c": 3, "v": 4,
        "a": 5, "s": 6, "d": 7, "f": 8,
        "q": 9, "w": 10, "e": 11, "r": 12,
        "1": 13, "2": 14, "3": 15, "4": 16,
    ]

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("TrackChop")
                        .font(.title2.bold())
                        .foregroundStyle(.orange)
                    Spacer()
                    trackpadStatusBadge
                }
                PadGridView(pads: padBank.pads, triggeredPads: triggeredPads, onPress: trigger, onRelease: release)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Trackpad")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.7))
                TrackpadCaptureView(touches: $touches, onTrigger: trigger, onRelease: release)
                    .frame(width: 360, height: 240)
                    .background(Color.black.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                touchReadout
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.09, green: 0.09, blue: 0.1).ignoresSafeArea())
        .focusable()
        .focusEffectDisabled()
        .focused($isFocused)
        .onAppear { isFocused = true }
        .onKeyPress(phases: [.down, .repeat, .up]) { press in
            guard let char = press.characters.lowercased().first, let pad = keyPadMap[char] else { return .ignored }
            if press.phase == .down {
                trigger(pad)
            } else if press.phase == .up {
                release(pad)
            }
            return .handled
        }
    }

    private var trackpadStatusBadge: some View {
        HStack(spacing: 6) {
            Circle().fill(Color.green).frame(width: 8, height: 8)
            Text("Trackpad Active")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var touchReadout: some View {
        VStack(alignment: .leading, spacing: 2) {
            if touches.isEmpty {
                Text("no touch").foregroundStyle(.gray)
            } else {
                ForEach(touches) { t in
                    Text(String(format: "id %d  x %.2f  y %.2f  pad %2d  %@", t.id, t.x, t.y, t.pad, t.phase))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.mint)
                }
            }
        }
        .frame(height: 80, alignment: .top)
    }

    private func trigger(_ pad: Int) {
        triggeredPads.insert(pad)
        voicePool.trigger(pad: pad)
    }

    private func release(_ pad: Int) {
        triggeredPads.remove(pad)
        voicePool.release(pad: pad)
    }
}
