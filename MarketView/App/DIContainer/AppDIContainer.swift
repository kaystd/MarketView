//
//  AppDIContainer.swift
//  MarketView
//
//  Created by Данил Кайст on 24.06.2025.
//

import Foundation
import SwiftUICore


class AppDIContainer {
    lazy var appConfig = AppConfig()

    lazy var stocks: StocksDIContainer = {
        makeStocksDIContainer()
    }()

    lazy var apiDataTransferService: DataTransferService = {
        let config = NetworkConfig(baseURL: URL(string: appConfig.apiBaseURL)!)
        let network = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: network)
    }()

    func makeStocksDIContainer() -> StocksDIContainer {
        let dependencies = StocksDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return StocksDIContainer(dependencies: dependencies)
    }
}

extension EnvironmentValues {
    @Entry var injected: AppDIContainer = AppDIContainer()
}
