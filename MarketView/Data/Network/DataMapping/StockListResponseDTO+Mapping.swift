//
//  StockListResponseDTO+Mapping.swift
//  MarketView
//
//  Created by Данил Кайст on 17.06.2025.
//

import Foundation


typealias StockListResponseDTO = [StockDTO]

struct StockDTO: Decodable {
    let symbol: String
    let price: String
    let dailyChange: String
    
    func toDomain() -> Stock {
        return .init(ticker: symbol, price: Double(price) ?? 0, change: Double(dailyChange) ?? 0)
    }
}
