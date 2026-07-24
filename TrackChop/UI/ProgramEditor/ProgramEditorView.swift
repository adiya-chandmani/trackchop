import SwiftUI

/// Abbreviated Program Edit — PRD §10 requires it in MVP even in reduced form.
/// Full parameter set (Filter, ADSR, Root Note, etc.) is post-MVP; this covers
/// what Day 4's engine actually supports: Volume/Pan/Tune/Reverse/Mode/Choke.
struct ProgramEditorView: View {
    @EnvironmentObject private var padBank: PadBank
    @EnvironmentObject private var voicePool: PadVoicePool
    @State private var selectedPad = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Program Edit").font(.title2.bold()).foregroundStyle(.orange)
            padSelector

            if let pad = currentPad, pad.isLoaded {
                controls(for: pad)
            } else {
                Text("Pad \(selectedPad) is empty").foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var currentPad: Pad? {
        padBank.pads.first { $0.index == selectedPad }
    }

    private var padSelector: some View {
        let rows: [[Int]] = [[13, 14, 15, 16], [9, 10, 11, 12], [5, 6, 7, 8], [1, 2, 3, 4]]
        return VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { padIndex in
                        let pad = padBank.pads.first { $0.index == padIndex }
                        Button {
                            selectedPad = padIndex
                        } label: {
                            Text("\(padIndex)")
                                .font(.system(.caption, design: .monospaced))
                                .frame(width: 40, height: 32)
                                .background(selectedPad == padIndex ? Color.orange : (pad?.isLoaded == true ? Color(white: 0.26) : Color(white: 0.14)))
                                .foregroundStyle(selectedPad == padIndex ? .black : .white.opacity(pad?.isLoaded == true ? 0.9 : 0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func controls(for pad: Pad) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(pad.slice?.name ?? "")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))

            labeledSlider("Volume", value: pad.volume, range: 0...1, format: "%.2f",
                           onChange: setParameter(pad.index) { $0.volume = $1 })
            labeledSlider("Pan", value: pad.pan, range: -1...1, format: "%.2f",
                           onChange: setParameter(pad.index) { $0.pan = $1 })
            labeledSlider("Tune", value: pad.tuneSemitones, range: -24...24, format: "%.0f st",
                           onChange: setParameter(pad.index) { $0.tuneSemitones = $1 })

            Toggle("Reverse", isOn: Binding(
                get: { pad.reverse },
                set: { newValue in
                    let updated = padBank.update(pad.index) { $0.reverse = newValue }
                    voicePool.loadPads(updated)
                }
            ))

            Picker("Playback", selection: Binding(
                get: { pad.playbackMode },
                set: { newValue in
                    let updated = padBank.update(pad.index) { $0.playbackMode = newValue }
                    voicePool.applyParameters(updated)
                }
            )) {
                ForEach(PlaybackMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 240)

            HStack {
                Text("Choke Group").font(.caption).foregroundStyle(.white.opacity(0.6))
                Picker("", selection: Binding(
                    get: { pad.chokeGroup },
                    set: { newValue in
                        let updated = padBank.update(pad.index) { $0.chokeGroup = newValue }
                        voicePool.applyParameters(updated)
                    }
                )) {
                    Text("None").tag(Optional<Int>.none)
                    ForEach(1...4, id: \.self) { group in
                        Text("Group \(group)").tag(Optional(group))
                    }
                }
                .labelsHidden()
                .frame(width: 140)
            }

            Button("Preview") { voicePool.trigger(pad: pad.index) }
        }
    }

    private func labeledSlider(_ title: String, value: Double, range: ClosedRange<Double>, format: String, onChange: @escaping (Double) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title).font(.caption).foregroundStyle(.white.opacity(0.6))
                Spacer()
                Text(String(format: format, value)).font(.system(.caption, design: .monospaced))
            }
            Slider(value: Binding(get: { value }, set: onChange), in: range)
        }
        .frame(maxWidth: 320)
    }

    private func setParameter(_ index: Int, _ mutate: @escaping (inout Pad, Double) -> Void) -> (Double) -> Void {
        { newValue in
            let updated = padBank.update(index) { mutate(&$0, newValue) }
            voicePool.applyParameters(updated)
        }
    }
}
