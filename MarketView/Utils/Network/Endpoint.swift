//
//  Endpoint.swift
//  MarketView
//
//  Created by Данил Кайст on 16.06.2025.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var parameters: [URLQueryItem] { get }
    func makeUrlRequest() -> URLRequest?
}
