//
//  StockListRepository.swift
//  MarketView
//
//  Created by Данил Кайст on 19.06.2025.
//

import Foundation


protocol StockListRepository {
    func fetchStockList() async throws -> [Stock]
}
