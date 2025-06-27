//
//  AnimatedText.swift
//  MarketView
//
//  Created by Данил Кайст on 26.06.2025.
//

import SwiftUI


struct AnimatedText: View {
    let text: String
    @State private var color: Color = .primary

    var body: some View {
        return Text(text)
            .onChange(of: text) { oldValue, newValue in
                let newValueDouble = (Double(newValue) ?? 0.0)
                let oldValueDouble = (Double(oldValue) ?? 0.0)
                let change = newValueDouble - oldValueDouble
                color = change > 0 ? .green : change < 0 ? .red : .primary

                if color != .primary {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut(duration: 4)) { color = .primary }
                    }
                }
            }
            .foregroundStyle(color)
    }
}
