import SwiftUI

/// 4x4 grid, pad 1 bottom-left to pad 16 top-right (PRD 11.6).
struct PadGridView: View {
    let activePads: Set<Int>
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
                    ForEach(row, id: \.self) { pad in
                        PadButton(index: pad, isActive: activePads.contains(pad)) {
                            onTrigger(pad)
                        }
                    }
                }
            }
        }
    }
}

private struct PadButton: View {
    let index: Int
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(index)")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(isActive ? .black : .white.opacity(0.85))
                .frame(width: 64, height: 64)
                .background(isActive ? Color.orange : Color(white: 0.18))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
