import Foundation

struct Pad: Identifiable {
    let index: Int
    var slice: Slice?

    var id: Int { index }
    var isLoaded: Bool { slice != nil }
}
