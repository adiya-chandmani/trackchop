import SwiftUI

/// 4x4 grid, pad 1 bottom-left to pad 16 top-right (PRD 11.6).
struct PadGridView: View {
    let pads: [Pad]
    let triggeredPads: Set<Int>
    let onTrigger: (Int) -> Void

    private let rows: [[Int]] = [
        [13, 14, 15, 16],
        [9, 10, 11, 12],
        [5, 6, 7, 8],
        [1, 2, 3, 4],
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { padIndex in
                        PadButton(
                            index: padIndex,
                            isLoaded: pads[safe: padIndex - 1]?.isLoaded ?? false,
                            isTriggered: triggeredPads.contains(padIndex)
                        ) {
                            onTrigger(padIndex)
                        }
                    }
                }
            }
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private struct PadButton: View {
    let index: Int
    let isLoaded: Bool
    let isTriggered: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(index)")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(isTriggered ? .black : (isLoaded ? .white.opacity(0.9) : .white.opacity(0.3)))
                .frame(width: 64, height: 64)
                .background(isTriggered ? Color.orange : (isLoaded ? Color(white: 0.26) : Color(white: 0.14)))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
