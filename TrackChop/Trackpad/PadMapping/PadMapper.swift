import Foundation

/// Maps a trackpad's normalized touch position (0,0 bottom-left – 1,1 top-right)
/// to a 4x4 pad index. Pad 1 is bottom-left, Pad 16 is top-right (PRD 11.6).
enum PadMapper {
    static func pad(forNormalizedX x: Double, y: Double) -> Int {
        let col = min(3, max(0, Int(x * 4)))
        let row = min(3, max(0, Int(y * 4)))
        return row * 4 + col + 1
    }
}
