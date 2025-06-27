//
//  AboutView.swift
//  MarketView
//
//  Created by Данил Кайст on 27.06.2025.
//

import SwiftUI


struct AboutView: View {
    @Environment(\.injected) private var injected: AppDIContainer

    @Binding var selectedTab: RootView.Tab

    var body: some View {
        VStack(spacing: 32) {
            Text("MarketView App")
                .font(.largeTitle)
            Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
            Button("To Stocks") {
                selectedTab = RootView.Tab.stocks
            }
        }
        
    }
}

#Preview {
    @Previewable @State var selection = RootView.Tab.stocks
    AboutView(selectedTab: $selection)
}
