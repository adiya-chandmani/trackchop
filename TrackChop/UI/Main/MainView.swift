import SwiftUI

struct MainView: View {
    @EnvironmentObject private var padBank: PadBank
    @EnvironmentObject private var voicePool: PadVoicePool
    @State private var triggeredPads: Set<Int> = []
    @State private var touches: [TrackpadTouch] = []

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                Text("TrackChop")
                    .font(.title2.bold())
                    .foregroundStyle(.orange)
                PadGridView(pads: padBank.pads, triggeredPads: triggeredPads, onTrigger: trigger)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Trackpad")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.7))
                TrackpadCaptureView(touches: $touches, onTrigger: trigger)
                    .frame(width: 360, height: 240)
                    .background(Color.black.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                touchReadout
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.09, green: 0.09, blue: 0.1).ignoresSafeArea())
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            triggeredPads.remove(pad)
        }
    }
}
