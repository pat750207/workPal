// APIEndpoint.swift
// WorkPal — Core/Network

import Foundation

// MARK: - Endpoint 定義
struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]?
    let body: Data?

    private static let baseURL = "https://api.workpal.example.com/v1"

    var url: URL? {
        var components = URLComponents(string: Self.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }

    // MARK: - 預設 Header
    init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = ["Content-Type": "application/json"],
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}

// MARK: - Task 相關 Endpoints
extension APIEndpoint {
    static func fetchTasks() -> APIEndpoint {
        APIEndpoint(path: "/tasks")
    }

    static func createTask(_ task: TaskItem) -> APIEndpoint {
        let body = try? JSONEncoder().encode(task)
        return APIEndpoint(path: "/tasks", method: .post, body: body)
    }

    static func updateTask(_ task: TaskItem) -> APIEndpoint {
        let body = try? JSONEncoder().encode(task)
        return APIEndpoint(path: "/tasks/\(task.id)", method: .put, body: body)
    }

    static func deleteTask(id: String) -> APIEndpoint {
        APIEndpoint(path: "/tasks/\(id)", method: .delete)
    }
}
