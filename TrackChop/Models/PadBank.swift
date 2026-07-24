import Foundation

final class PadBank: ObservableObject {
    @Published private(set) var pads: [Pad] = (1...16).map { Pad(index: $0) }

    @discardableResult
    func assign(slices: [Slice]) -> [Pad] {
        var newPads = (1...16).map { Pad(index: $0) }
        for (i, slice) in slices.prefix(16).enumerated() {
            newPads[i].slice = slice
        }
        pads = newPads
        return newPads
    }
}
