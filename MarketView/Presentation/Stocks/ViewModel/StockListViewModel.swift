//
//  StockListViewModel.swift
//  MarketView
//
//  Created by Данил Кайст on 17.06.2025.
//

import Foundation


protocol StockListViewModel: ObservableObject {
    var stocks: [StockListItemViewModel] { get }
    var loading: Bool { get }
    var errorMessage: String { get }
    func didUpdate()
    func didCancel()
}

final class DefaultStockListViewModel: StockListViewModel {
    private let fetchMainStocksUseCase: FetchMainStocksUseCase

    init(fetchMainStocksUseCase: FetchMainStocksUseCase) {
        self.fetchMainStocksUseCase = fetchMainStocksUseCase
    }

    private var stockUpdateTask: Task<Void, Never>?
    @Published var stocks = [StockListItemViewModel]()
    @Published var loading = false
    @Published var errorMessage = ""

    func updateStocks() {
        defer {
            loading = false
        }

        loading = true

        stockUpdateTask?.cancel()
        stockUpdateTask = Task {
            do {
                let stockList: [Stock] = try await fetchMainStocksUseCase.execute()
                DispatchQueue.main.async {
                    self.stocks = stockList.map(StockListItemViewModel.init)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }
        }
    }
}

extension DefaultStockListViewModel {
    func didUpdate() {
        updateStocks()
    }

    func didCancel() {
        stockUpdateTask?.cancel()
    }
}
