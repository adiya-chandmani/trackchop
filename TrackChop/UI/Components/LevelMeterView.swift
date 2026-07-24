import SwiftUI

struct LevelMeterView: View {
    let db: Float

    private var normalized: CGFloat {
        let clamped = max(-60, min(0, db))
        return CGFloat((clamped + 60) / 60)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3).fill(Color(white: 0.2))
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.green)
                    .frame(width: geo.size.width * normalized)
            }
        }
    }
}
