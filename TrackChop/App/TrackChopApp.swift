import SwiftUI

@main
struct TrackChopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 640)
        }
        .windowResizability(.contentSize)
    }
}
