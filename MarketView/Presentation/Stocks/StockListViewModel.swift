//
//  StockListViewModel.swift
//  MarketView
//
//  Created by Данил Кайст on 17.06.2025.
//

import Foundation


protocol StockListViewModel: ObservableObject {
    var stocks: [Stock] { get }
    var loading: Bool { get }
    var errorMessage: String { get }
}

final class DefaultStockListViewModel: StockListViewModel {
    private let fetchMainStocksUseCase: FetchMainStocksUseCase

    init(fetchMainStocksUseCase: FetchMainStocksUseCase) {
        self.fetchMainStocksUseCase = fetchMainStocksUseCase
    }

    private var stockUpdateTask: Task<Void, Never>?
    @Published var stocks = [Stock]()
    @Published var loading = false
    @Published var errorMessage = ""

    func updateStocks() {
        defer {
            loading = false
        }
        stockUpdateTask = Task(priority: .medium) {
            do {
                loading = true
                stocks = try await fetchMainStocksUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
                print(error)
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
