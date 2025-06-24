//
//  StockListItemViewModel.swift
//  MarketView
//
//  Created by Данил Кайст on 23.06.2025.
//

import Foundation

class StockListItemViewModel: Identifiable {
    let ticker: String
    let price: String
    let change: String
    
    init(stock: Stock) {
        self.ticker = stock.ticker
        self.price = String(format: "%.2f", stock.price)
        self.change = String(format: "%.2f", stock.change)
    }
}
