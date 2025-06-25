//
//  StocksDIContainer.swift
//  MarketView
//
//  Created by Данил Кайст on 24.06.2025.
//

import Foundation


final class StocksDIContainer {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeFetchMainStocksUseCase() -> FetchMainStocksUseCase {
        DefaultFetchMainStocksUseCase(
            stockListRepository: makeStockListRepository(),
        )
    }

    func makeStockListRepository() -> StockListRepository {
        DefaultStockListRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    func makeStockListViewModel() -> some StockListViewModel {
        DefaultStockListViewModel(fetchMainStocksUseCase: makeFetchMainStocksUseCase())
    }
}
