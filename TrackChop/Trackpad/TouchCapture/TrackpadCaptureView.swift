import AppKit
import SwiftUI

struct TrackpadTouch: Identifiable {
    let id: Int
    let x: Double
    let y: Double
    let pad: Int
    let phase: String
}

struct TrackpadCaptureView: NSViewRepresentable {
    @Binding var touches: [TrackpadTouch]
    let onTrigger: (Int) -> Void

    func makeNSView(context: Context) -> TouchCaptureNSView {
        let view = TouchCaptureNSView()
        view.onTouchesChanged = { touches in
            self.touches = touches
        }
        view.onTrigger = onTrigger
        return view
    }

    func updateNSView(_ nsView: TouchCaptureNSView, context: Context) {}
}

/// Day 1 spike: reads AppKit indirect touch events and logs identity/position/phase.
/// Dead zone / hysteresis at pad boundaries is Day 4 scope (PRD 11.7).
final class TouchCaptureNSView: NSView {
    var onTouchesChanged: (([TrackpadTouch]) -> Void)?
    var onTrigger: ((Int) -> Void)?
    private var triggered: Set<Int> = []

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsRestingTouches = true
        allowedTouchTypes = [.indirect]
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsRestingTouches = true
        allowedTouchTypes = [.indirect]
    }

    override func touchesBegan(with event: NSEvent) {
        handle(event, phase: "began")
    }

    override func touchesMoved(with event: NSEvent) {
        handle(event, phase: "moved")
    }

    override func touchesEnded(with event: NSEvent) {
        handle(event, phase: "ended")
        for touch in event.touches(matching: .ended, in: self) {
            triggered.remove(ObjectIdentifier(touch.identity as AnyObject).hashValue)
        }
    }

    override func touchesCancelled(with event: NSEvent) {
        handle(event, phase: "cancelled")
        for touch in event.touches(matching: .cancelled, in: self) {
            triggered.remove(ObjectIdentifier(touch.identity as AnyObject).hashValue)
        }
    }

    private func handle(_ event: NSEvent, phase: String) {
        let active = event.touches(matching: .touching, in: self)
        var rows: [TrackpadTouch] = []
        for touch in active {
            let pos = touch.normalizedPosition
            let pad = PadMapper.pad(forNormalizedX: pos.x, y: pos.y)
            let key = ObjectIdentifier(touch.identity as AnyObject).hashValue
            rows.append(TrackpadTouch(id: key, x: pos.x, y: pos.y, pad: pad, phase: phase))
            if phase == "began" && !triggered.contains(key) {
                triggered.insert(key)
                onTrigger?(pad)
            }
        }
        onTouchesChanged?(rows)
    }
}
