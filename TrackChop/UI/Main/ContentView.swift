import SwiftUI

/// Mode switcher — PRD 8.3 "Clear Modes". Sequencer / Mixer join once their
/// days land; Song is out of MVP scope entirely.
enum AppMode: String, CaseIterable, Identifiable {
    case main = "Main"
    case sampleEdit = "Sample Edit"
    case programEdit = "Program Edit"
    var id: String { rawValue }
}

struct ContentView: View {
    @State private var mode: AppMode = .main
    @StateObject private var padBank = PadBank()
    @StateObject private var voicePool = PadVoicePool()

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $mode) {
                ForEach(AppMode.allCases) { m in
                    Text(m.rawValue).tag(m)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(12)
            .background(Color(white: 0.12))

            Group {
                switch mode {
                case .main:
                    MainView()
                case .sampleEdit:
                    SampleEditorView()
                case .programEdit:
                    ProgramEditorView()
                }
            }
            .foregroundStyle(.white)
            .environmentObject(padBank)
            .environmentObject(voicePool)
        }
        .background(Color(red: 0.09, green: 0.09, blue: 0.1).ignoresSafeArea())
    }
}
