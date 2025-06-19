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
    let price: Double
    let daylyChange: Double
    
    func toDomain() -> Stock {
        return .init(ticker: symbol, price: price, change: daylyChange)
    }
}
