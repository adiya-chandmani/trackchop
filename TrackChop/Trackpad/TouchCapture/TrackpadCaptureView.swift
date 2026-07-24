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
    let onRelease: (Int) -> Void

    func makeNSView(context: Context) -> TouchCaptureNSView {
        let view = TouchCaptureNSView()
        view.onTouchesChanged = { touches in
            self.touches = touches
        }
        view.onTrigger = onTrigger
        view.onRelease = onRelease
        return view
    }

    func updateNSView(_ nsView: TouchCaptureNSView, context: Context) {}
}

/// Reads AppKit indirect touch events, maps to a 4x4 pad, and fires trigger/release
/// per touch identity. A dead zone near cell boundaries keeps the reported pad from
/// flickering when a finger rests on a line (PRD 11.7).
final class TouchCaptureNSView: NSView {
    var onTouchesChanged: (([TrackpadTouch]) -> Void)?
    var onTrigger: ((Int) -> Void)?
    var onRelease: ((Int) -> Void)?
    private var touchPad: [Int: Int] = [:]
    private let deadZone: Double = 0.05

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
        endTouches(event.touches(matching: .ended, in: self))
    }

    override func touchesCancelled(with event: NSEvent) {
        handle(event, phase: "cancelled")
        endTouches(event.touches(matching: .cancelled, in: self))
    }

    private func endTouches(_ touchSet: Set<NSTouch>) {
        for touch in touchSet {
            let key = ObjectIdentifier(touch.identity as AnyObject).hashValue
            if let pad = touchPad.removeValue(forKey: key) {
                onRelease?(pad)
            }
        }
    }

    private func handle(_ event: NSEvent, phase: String) {
        let active = event.touches(matching: .touching, in: self)
        var rows: [TrackpadTouch] = []
        for touch in active {
            let pos = touch.normalizedPosition
            let key = ObjectIdentifier(touch.identity as AnyObject).hashValue
            let pad = resolvePad(x: pos.x, y: pos.y, previous: touchPad[key])
            rows.append(TrackpadTouch(id: key, x: pos.x, y: pos.y, pad: pad, phase: phase))
            if phase == "began" && touchPad[key] == nil {
                touchPad[key] = pad
                onTrigger?(pad)
            }
        }
        onTouchesChanged?(rows)
    }

    private func resolvePad(x: Double, y: Double, previous: Int?) -> Int {
        let raw = PadMapper.pad(forNormalizedX: x, y: y)
        guard let previous, previous != raw else { return raw }
        let cell = 0.25
        let fracX = (x / cell).truncatingRemainder(dividingBy: 1)
        let fracY = (y / cell).truncatingRemainder(dividingBy: 1)
        let nearBoundary = fracX < deadZone || fracX > 1 - deadZone || fracY < deadZone || fracY > 1 - deadZone
        return nearBoundary ? previous : raw
    }
}
