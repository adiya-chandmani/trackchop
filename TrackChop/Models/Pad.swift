import Foundation

enum PlaybackMode: String, CaseIterable, Identifiable {
    case oneShot = "One Shot"
    case hold = "Hold"
    var id: String { rawValue }
}

struct Pad: Identifiable {
    let index: Int
    var slice: Slice?
    var volume: Double = 1.0
    var pan: Double = 0.0
    var tuneSemitones: Double = 0.0
    var reverse: Bool = false
    var playbackMode: PlaybackMode = .oneShot
    var chokeGroup: Int?

    var id: Int { index }
    var isLoaded: Bool { slice != nil }
}
