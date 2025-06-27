//
//  AboutView.swift
//  MarketView
//
//  Created by Данил Кайст on 27.06.2025.
//

import SwiftUI


struct AboutView: View {
    @Environment(\.injected) private var injected: AppDIContainer

    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        VStack(spacing: 32) {
            Text("MarketView App")
                .font(.largeTitle)
            Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
            Button("To Stocks") {
                selectedTab = ContentView.Tab.stocks
            }
        }
        
    }
}

#Preview {
    @Previewable @State var selection = ContentView.Tab.stocks
    AboutView(selectedTab: $selection)
}
