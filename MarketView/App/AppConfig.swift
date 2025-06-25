//
//  AppConfig.swift
//  MarketView
//
//  Created by Данил Кайст on 24.06.2025.
//

import Foundation


class AppConfig {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey not found in Info.plist")
        }
        return apiKey
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "ApiBaseUrl") as? String else {
            fatalError("ApiBaseUrl not found in Info.plist")
        }
        return apiBaseUrl
    }()
}
