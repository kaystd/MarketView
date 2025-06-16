//
//  StockAPI.swift
//  MarketView
//
//  Created by Данил Кайст on 16.06.2025.
//

import Foundation

enum StockAPI {
    case quote(ticker: String)
}

extension StockAPI: Endpoint {
    private static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "ApiKey", ofType: "plist") else {
            fatalError("File not found")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let apiKey = plist?["API_KEY"] as? String else {
            fatalError("Key not found")
        }
        return apiKey
    }

    var scheme: String {
        return "https"
    }

    var baseURL: String {
        return "https://www.alphavantage.co"
//        return "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo"
    }

    var method: String {
        return "GET"
    }
    
    var path: String {
        switch self {
        case .quote:
            return "/query"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .quote(ticker: let ticker):
            return [
                URLQueryItem(name: "function", value: "GLOBAL_QUOTE"),
                URLQueryItem(name: "symbol", value: ticker),
                URLQueryItem(name: "apikey", value: StockAPI.apiKey)
            ]
        }
    }

    var body: Data? {
        return nil
    }

    func makeUrlRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseURL
        urlComponents.path = path

        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = body
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue(StockAPI.apiKey, forHTTPHeaderField: "x-api-key")

        return urlRequest
    }
}
