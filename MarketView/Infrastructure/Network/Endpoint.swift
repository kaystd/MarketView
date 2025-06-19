//
//  Endpoint.swift
//  MarketView
//
//  Created by Данил Кайст on 16.06.2025.
//

import Foundation


enum HTTPMethod: String {
    case head = "HEAD"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum RequestGenerationError: Error {
    case components
}

class Endpoint<R>: ResponseRequestable {
    typealias Response = R

    let path: String
    let method: HTTPMethod
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let bodyParameters: [String: Any]
    let bodyEncoder: BodyEncoder
    let responseDecoder: ResponseDecoder

    init(
        path: String,
        method: HTTPMethod,
        headerParameters: [String : String] = [:],
        queryParameters: [String : Any] = [:],
        bodyParameters: [String : Any] = [:],
        bodyEncoder: BodyEncoder = JSONBodyEncoder(),
        responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

protocol ResponseRequestable: Requestable {
    associatedtype Response

    var responseDecoder: ResponseDecoder { get }
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethod { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoder: BodyEncoder { get }

    func makeUrlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)

        guard var urlComponents = URLComponents(string: endpoint) else {
            throw RequestGenerationError.components
        }

        var urlQueryItems = [URLQueryItem]()
        let queryParameters = self.queryParameters
        queryParameters.forEach { key, value in
            urlQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        config.queryParameters.forEach { key, value in
            urlQueryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else {
            throw RequestGenerationError.components
        }
        return url
    }

    func makeUrlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        let bodyParameters = self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}
