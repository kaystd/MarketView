import SwiftUI

struct ContentView: View {
    @Environment(\.injected) private var injected: AppDIContainer

    @State private var selection = Tab.stocks

    enum Tab {
        case stocks
        case about
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                StockListView(viewModel: injected.stocks.makeStockListViewModel())
                    .navigationTitle("Stocks")
                    .navigationBarTitleDisplayMode(.large)
            }
                .tabItem {
                    Label("Stocks", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.stocks)
            NavigationStack {
                AboutView(selectedTab: $selection)
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
