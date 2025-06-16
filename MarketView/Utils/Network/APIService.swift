//
//  File.swift
//  MarketView
//
//  Created by Данил Кайст on 16.06.2025.
//

import Foundation

enum NetwokError: Error {
    case makeRequestError
    case invalidEndpoint
    case limitExceeded
    case serverError(statusCode: Int)
    case decodingError

    var description: String {
        switch self {
        case .makeRequestError:
            return "Network error. Invalid request"
        case .invalidEndpoint:
            return "Network error. Invalid endpoint"
        case .limitExceeded:
            return "Network error. Request limit exceeded"
        case .serverError(statusCode: let code):
            return "Network error. Status code: \(code)"
        case .decodingError:
            return "Network error. Can not decode response"
        }
    }
}

protocol APIService {
    func makeRequest<T: Codable>(session: URLSession, endpoint: Endpoint) async throws -> T
}

class APIServiceImpl: APIService {
    func makeRequest<T: Codable>(session: URLSession, endpoint: Endpoint) async throws -> T {
        guard let request = endpoint.makeUrlRequest() else {
            throw NetwokError.makeRequestError
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetwokError.invalidEndpoint
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw if httpResponse.statusCode == 429 {
                NetwokError.limitExceeded
            } else {
                NetwokError.serverError(statusCode: httpResponse.statusCode)
            }
        }

        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print("DECODING_ERROR", error)
            throw NetwokError.decodingError
        }
    }
}
