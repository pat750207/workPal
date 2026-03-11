// TaskService.swift
// WorkPal — Features/TaskList/Models
//
// ✅ Protocol-based Service — 對應 UIKit 中的 Manager / Repository
// ✅ 可被 MockTaskService 取代，進行 Unit Test

import Foundation

// MARK: - Protocol（可 Mock）
protocol TaskServiceProtocol {
    func fetchTasks() async throws -> [TaskItem]
    func createTask(_ task: TaskItem) async throws -> TaskItem
    func updateTask(_ task: TaskItem) async throws -> TaskItem
    func deleteTask(id: String) async throws
}

// MARK: - 實作
final class TaskService: TaskServiceProtocol {

    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol) {
        self.client = client
    }

    func fetchTasks() async throws -> [TaskItem] {
        try await client.request(.fetchTasks(), as: [TaskItem].self)
    }

    func createTask(_ task: TaskItem) async throws -> TaskItem {
        try await client.request(.createTask(task), as: TaskItem.self)
    }

    func updateTask(_ task: TaskItem) async throws -> TaskItem {
        try await client.request(.updateTask(task), as: TaskItem.self)
    }

    func deleteTask(id: String) async throws {
        let _: EmptyResponse = try await client.request(.deleteTask(id: id), as: EmptyResponse.self)
    }
}

// MARK: - Mock（Unit Test 用）
final class MockTaskService: TaskServiceProtocol {

    var mockTasks: [TaskItem] = TaskItem.mocks
    var shouldThrowError = false
    var mockError: NetworkError = .unknown("Mock error")

    func fetchTasks() async throws -> [TaskItem] {
        if shouldThrowError { throw mockError }
        return mockTasks
    }

    func createTask(_ task: TaskItem) async throws -> TaskItem {
        if shouldThrowError { throw mockError }
        mockTasks.append(task)
        return task
    }

    func updateTask(_ task: TaskItem) async throws -> TaskItem {
        if shouldThrowError { throw mockError }
        if let index = mockTasks.firstIndex(where: { $0.id == task.id }) {
            mockTasks[index] = task
        }
        return task
    }

    func deleteTask(id: String) async throws {
        if shouldThrowError { throw mockError }
        mockTasks.removeAll { $0.id == id }
    }
}

// MARK: - Helper
private struct EmptyResponse: Decodable {}

// MARK: - Mock Data
extension TaskItem {
    static let mocks: [TaskItem] = [
        TaskItem(id: "1", title: "設計新版首頁", description: "根據設計稿實作 SwiftUI 版本", priority: .high,
                 dueDate: Date().addingTimeInterval(86400)),
        TaskItem(id: "2", title: "撰寫 Unit Test", description: "覆蓋率至少 80%", priority: .medium),
        TaskItem(id: "3", title: "Code Review", description: "", isCompleted: true, priority: .low),
        TaskItem(id: "4", title: "更新 API 文件", description: "同步 Swagger 規格", priority: .medium,
                 dueDate: Date().addingTimeInterval(-3600)) // 已逾期
    ]
}
