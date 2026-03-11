// AppContainer.swift
// WorkPal — Core/DI
//
// 依賴注入容器 — 統一管理所有物件的建立與生命週期
// 方便 Unit Test 時抽換 Mock 實作

import Foundation

final class AppContainer {

    // MARK: - Shared Singletons
    private lazy var httpClient: HTTPClientProtocol = HTTPClient()

    // MARK: - Services
    private lazy var taskService: TaskServiceProtocol = TaskService(client: httpClient)

    // MARK: - ViewModels Factory
    @MainActor
    func makeTaskListViewModel() -> TaskListViewModel {
        TaskListViewModel(service: taskService)
    }

    @MainActor
    func makeTaskDetailViewModel(task: TaskItem) -> TaskDetailViewModel {
        TaskDetailViewModel(task: task, service: taskService)
    }
}
