import SwiftUI

struct ContentView: View {
    @State private var selection = Tab.stocks

    enum Tab {
        case stocks
        case about
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                Text("Stocks")
                    .navigationTitle("Stocks")
                    .navigationBarTitleDisplayMode(.large)
            }
                .tabItem {
                    Label("Stocks", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.stocks)
            NavigationStack {
                Text("About")
                    .navigationTitle("About")
                    .navigationBarTitleDisplayMode(.large)
            }
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
