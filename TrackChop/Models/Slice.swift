import Foundation

struct Slice: Identifiable, Equatable {
    let id = UUID()
    var sourceURL: URL
    var startTime: TimeInterval
    var endTime: TimeInterval
    var name: String

    var duration: TimeInterval { endTime - startTime }
}
