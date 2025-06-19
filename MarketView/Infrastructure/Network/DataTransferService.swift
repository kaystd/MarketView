//
//  DataTransferService.swift
//  MarketView
//
//  Created by Данил Кайст on 19.06.2025.
//

import Foundation


enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFalure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T where E.Response == T
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}


final class DefaultDataTransferService {
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger

    init(
        with networkService: NetworkService,
        errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T where E.Response == T {
        do {
            let data = try await networkService.request(endpoint: endpoint)
            return try await decode(data: data, decoder: endpoint.responseDecoder)
        } catch let networkError as NetworkError {
            self.errorLogger.log(error: networkError)
            throw self.resove(networkError: networkError)
        } catch let decodingError as DecodingError {
            self.errorLogger.log(error: decodingError)
            throw DataTransferError.parsing(decodingError)
        }
    }

    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) async throws -> T {
        do {
            guard let data = data else {
                throw DataTransferError.noResponse
            }
            let result: T = try decoder.decode(data)
            return result
        } catch {
            self.errorLogger.log(error: error)
            throw DataTransferError.parsing(error)
        }
    }

    private func resove(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFalure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() {}

    func resolve(error: NetworkError) -> Error {
        return error
    }
}

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() {}

    func log(error: Error) {
        print("--------------------")
        print(" \(error)")
    }
}


class JSONResponseDecoder: ResponseDecoder {
    private let decoder = JSONDecoder()

    init() {}

    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
