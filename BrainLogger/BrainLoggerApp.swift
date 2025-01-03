import SwiftUI
import SwiftData

@main
struct BrainLoggerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:Todo.self)
    }
}
