// HTTPClient.swift
// WorkPal — Core/Network
//
// UIKit 對應：原本散落在 ViewController 或 Manager 的 URLSession 呼叫
// 改為 Protocol-based，方便 Mock 注入進行 Unit Test

import Foundation

// MARK: - Protocol（可 Mock）
protocol HTTPClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, as type: T.Type) async throws -> T
}

// MARK: - 實作
final class HTTPClient: HTTPClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, as type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        if let body = endpoint.body {
            urlRequest.httpBody = body
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}
