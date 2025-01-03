import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView{
            TodoView()
                .tabItem{
                    Label("Todo", systemImage: "list.bullet")
                }
            ArchiveView()
                .tabItem{
                    Label("Archive", systemImage: "archivebox")
                }
            LogView()
                .tabItem{
                    Label("Log", systemImage: "book")
            }
        }
    }

}

#Preview {
    ContentView()
}
