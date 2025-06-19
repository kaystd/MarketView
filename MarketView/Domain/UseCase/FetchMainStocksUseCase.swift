//
//  StockListUseCase.swift
//  MarketView
//
//  Created by Данил Кайст on 19.06.2025.
//

import Foundation


protocol FetchMainStocksUseCase {
    func execute() async throws -> [Stock]
}

final class DefaultFetchMainStocksUseCase: FetchMainStocksUseCase {
    let stockListRepository: StockListRepository

    init(stockListRepository: StockListRepository) {
        self.stockListRepository = stockListRepository
    }

    func execute() async throws -> [Stock] {
        try await stockListRepository.fetchStockList()
    }
}
