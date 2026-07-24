import SwiftUI

struct WaveformView: View {
    let peaks: [Float]
    let duration: TimeInterval
    @Binding var startMarker: TimeInterval
    @Binding var endMarker: TimeInterval
    @Binding var chopMarkers: [ChopMarker]
    let playheadTime: TimeInterval
    let onSeek: (TimeInterval) -> Void

    private enum DragTarget { case start, end }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            ZStack(alignment: .topLeading) {
                Canvas { context, size in
                    drawWaveform(context: context, size: size)
                }
                .frame(width: width, height: height)

                markerHandle(time: startMarker, width: width, height: height, color: .yellow)
                    .gesture(dragGesture(.start, width: width))
                markerHandle(time: endMarker, width: width, height: height, color: .orange)
                    .gesture(dragGesture(.end, width: width))
                ForEach($chopMarkers) { $marker in
                    markerHandle(time: marker.time, width: width, height: height, color: .white.opacity(0.85))
                        .gesture(chopDragGesture(marker: $marker, width: width))
                }
                playheadLine(time: playheadTime, width: width, height: height)
            }
            .frame(width: width, height: height)
            .coordinateSpace(name: "waveform")
            .contentShape(Rectangle())
            .gesture(
                SpatialTapGesture().onEnded { value in
                    guard width > 0 else { return }
                    onSeek(duration * Double(value.location.x / width))
                }
            )
        }
    }

    private func drawWaveform(context: GraphicsContext, size: CGSize) {
        guard peaks.count >= 2 else { return }
        let bucketCount = peaks.count / 2
        let midY = size.height / 2
        let barWidth = max(1, size.width / CGFloat(bucketCount))
        var path = Path()
        for i in 0..<bucketCount {
            let x = size.width * CGFloat(i) / CGFloat(bucketCount)
            let minV = CGFloat(peaks[i * 2])
            let maxV = CGFloat(peaks[i * 2 + 1])
            let yTop = midY - maxV * midY
            let yBottom = midY - minV * midY
            path.addRect(CGRect(x: x, y: yTop, width: barWidth, height: max(1, yBottom - yTop)))
        }
        context.fill(path, with: .color(.mint))
    }

    private func markerHandle(time: TimeInterval, width: CGFloat, height: CGFloat, color: Color) -> some View {
        let x = duration > 0 ? width * CGFloat(time / duration) : 0
        return ZStack {
            Color.clear.frame(width: 16, height: height).contentShape(Rectangle())
            Rectangle().fill(color).frame(width: 3, height: height)
        }
        .offset(x: x - 8)
    }

    private func playheadLine(time: TimeInterval, width: CGFloat, height: CGFloat) -> some View {
        let x = duration > 0 ? width * CGFloat(time / duration) : 0
        return Rectangle()
            .fill(Color.white.opacity(0.8))
            .frame(width: 1, height: height)
            .offset(x: x)
            .allowsHitTesting(false)
    }

    private func dragGesture(_ target: DragTarget, width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("waveform"))
            .onChanged { value in
                guard duration > 0, width > 0 else { return }
                let t = max(0, min(duration, duration * Double(value.location.x / width)))
                switch target {
                case .start: startMarker = min(t, endMarker - 0.01)
                case .end: endMarker = max(t, startMarker + 0.01)
                }
            }
    }

    private func chopDragGesture(marker: Binding<ChopMarker>, width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("waveform"))
            .onChanged { value in
                guard duration > 0, width > 0 else { return }
                let t = duration * Double(value.location.x / width)
                marker.wrappedValue.time = max(startMarker, min(endMarker, t))
            }
    }
}
