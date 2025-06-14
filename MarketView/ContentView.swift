import SwiftUI

struct ContentView: View {
    @State private var selection = Tab.stocks

    enum Tab {
        case stocks
        case about
    }

    var body: some View {
        TabView(selection: $selection) {
            Text("Stocks").padding(.vertical, 20)
                .tabItem {
                    Label("Stocks", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.stocks)
            Text("About")
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(Tab.about)
        }
    }
}

#Preview {
    ContentView()
}
