//
//  StockListRepository.swift
//  MarketView
//
//  Created by Данил Кайст on 19.06.2025.
//

import Foundation

final class DefaultStockListRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultStockListRepository: StockListRepository {
    func fetchStockList() async throws -> [Stock] {
        let endpoint = APIEndpoints.getStockList()
        let dtoList = try await self.dataTransferService.request(with: endpoint)
        return dtoList.map { $0.toDomain() }
    }
}
