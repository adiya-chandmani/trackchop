import Foundation

struct AudioSample: Identifiable {
    let id = UUID()
    var url: URL
    var displayName: String
    var duration: TimeInterval
    var sampleRate: Double
    var channelCount: Int
    /// Interleaved min/max pairs, downsampled for rendering (see WaveformGenerator.maxBuckets).
    var peaks: [Float]
    var startMarker: TimeInterval
    var endMarker: TimeInterval
}
