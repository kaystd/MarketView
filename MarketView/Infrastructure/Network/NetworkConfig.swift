//
//  NetworkConfig.swift
//  MarketView
//
//  Created by Данил Кайст on 18.06.2025.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct NetworkConfig : NetworkConfigurable {
    var baseURL: URL
    var headers: [String: String]
    var queryParameters: [String: String]

    init(
        baseURL: URL,
        headers: [String : String] = [:],
        queryParameters: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
