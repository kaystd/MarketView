//
//  StockListViewModel.swift
//  MarketView
//
//  Created by Данил Кайст on 17.06.2025.
//

import Foundation
import Combine


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

    deinit {
        stopRefresh()
    }

    private var stockUpdateTask: Task<Void, Never>?
    @Published var stocks = [StockListItemViewModel]()
    @Published var loading = false
    @Published var errorMessage = ""
    var timerPublisher: AnyCancellable?

    func updateStocks() {
        stocks.isEmpty ? loading = true : ()

        stockUpdateTask = Task {
            do {
                let stockList: [Stock] = try await fetchMainStocksUseCase.execute()
                DispatchQueue.main.async {
                    self.stocks = stockList.map(StockListItemViewModel.init)
                    self.loading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.loading = false
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }
        }
    }

    func startRefresh() {
        stopRefresh()
        updateStocks()
        timerPublisher = Timer
            .publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateStocks()
            }
    }

    func stopRefresh() {
        timerPublisher?.cancel()
        timerPublisher = nil
    }
}

extension DefaultStockListViewModel {
    func didUpdate() {
        startRefresh()
    }

    func didCancel() {
        stopRefresh()
    }
}
