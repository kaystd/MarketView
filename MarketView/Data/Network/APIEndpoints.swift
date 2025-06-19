//
//  StockAPI.swift
//  MarketView
//
//  Created by Данил Кайст on 16.06.2025.
//

import Foundation

struct APIEndpoints {
    static func getStockList() -> Endpoint<StockListResponseDTO> {
        return Endpoint(path: "markets/price", method: .get)
    }
}
