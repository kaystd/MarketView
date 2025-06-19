//
//  File.swift
//  MarketView
//
//  Created by Данил Кайст on 16.06.2025.
//

import Foundation


enum NetworkError: Error {
    case invalidEndpoint
    case serverError(statusCode: Int)
    case connectionError
    case generic(Error)
}

protocol NetworkService {
    func request(endpoint: Requestable) async throws -> Data
}

protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}


final class DefaultNetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger

    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }

    private func makeRequest(request: URLRequest) async throws -> Data {
        self.logger.log(request: request)

        do {
            let (data, response) = try await sessionManager.request(request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidEndpoint
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            self.logger.log(responseData: data, response: response)

            return data
        } catch let requestError {
            let error: NetworkError = resolve(error: requestError)

            self.logger.log(error: error)
            throw error
        }
    }

    private func resolve(error: Error) -> NetworkError {
        if let netwokError = error as? NetworkError {
            return netwokError
        }
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet, .timedOut:
            return .connectionError
        default:
            return .generic(error)
        }

    }
}

extension DefaultNetworkService: NetworkService {
    func request(endpoint: Requestable) async throws -> Data {
        let urlRequest = try endpoint.makeUrlRequest(with: config)
        return try await makeRequest(request: urlRequest)
    }
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
}

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    func log(request: URLRequest) {
        print("--------------------")
        print("Request: \(String(describing: request.url))")
        print("Method: \(String(describing: request.httpMethod))")
        print("Headers: \(String(describing: request.allHTTPHeaderFields))")
        print ("Body: \(String(describing: request.httpBody))")
        
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else {
            return
        }
        print("Response Data: \(String(describing: data))")
    }

    func log(error: Error) {
        print(error)
    }
}
