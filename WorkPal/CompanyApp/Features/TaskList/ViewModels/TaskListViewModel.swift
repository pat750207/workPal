// TaskListViewModel.swift
// WorkPal — Features/TaskList/ViewModels
//
// UIKit 對應：UIViewController 中的業務邏輯 + 網路請求
// ✅ ObservableObject + @Published — 對應 UIViewController 的手動 reload
// ✅ 所有狀態皆為 @Published，View 零邏輯
// ✅ 依賴注入 TaskServiceProtocol — 可 Unit Test

import Foundation

@MainActor
final class TaskListViewModel: ObservableObject {

    // MARK: - Published State（對應 UIKit 的 UI 屬性）
    @Published private(set) var tasks: [TaskItem] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: NetworkError?
    @Published var searchText = ""
    @Published var selectedFilter: FilterOption = .all
    @Published var showCreateTask = false

    // MARK: - Computed（純邏輯，可單獨測試）
    var filteredTasks: [TaskItem] {
        tasks
            .filter { task in
                switch selectedFilter {
                case .all:       return true
                case .pending:   return !task.isCompleted
                case .completed: return task.isCompleted
                case .overdue:   return task.isOverdue
                }
            }
            .filter { task in
                searchText.isEmpty ||
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.description.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var completedCount: Int { tasks.filter(\.isCompleted).count }
    var pendingCount: Int   { tasks.filter { !$0.isCompleted }.count }
    var hasError: Bool      { errorMessage != nil }

    // MARK: - Dependencies
    private let service: TaskServiceProtocol

    init(service: TaskServiceProtocol) {
        self.service = service
    }

    // MARK: - Intents（對應 UIKit 的 IBAction / Delegate 方法）

    /// 對應 viewDidLoad / viewWillAppear 的初始載入
    func loadTasks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            tasks = try await service.fetchTasks()
        } catch let error as NetworkError {
            errorMessage = error
        } catch {
            errorMessage = .unknown(error.localizedDescription)
        }
    }

    func toggleComplete(task: TaskItem) async {
        var updated = task
        updated.isCompleted.toggle()

        do {
            let result = try await service.updateTask(updated)
            if let index = tasks.firstIndex(where: { $0.id == result.id }) {
                tasks[index] = result
            }
        } catch let error as NetworkError {
            errorMessage = error
        } catch {
            errorMessage = .unknown(error.localizedDescription)
        }
    }

    func deleteTask(_ task: TaskItem) async {
        do {
            try await service.deleteTask(id: task.id)
            tasks.removeAll { $0.id == task.id }
        } catch let error as NetworkError {
            errorMessage = error
        } catch {
            errorMessage = .unknown(error.localizedDescription)
        }
    }

    func createTask(title: String, description: String, priority: TaskItem.Priority, dueDate: Date?) async {
        let newTask = TaskItem(
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate
        )
        do {
            let created = try await service.createTask(newTask)
            tasks.insert(created, at: 0)
        } catch let error as NetworkError {
            errorMessage = error
        } catch {
            errorMessage = .unknown(error.localizedDescription)
        }
    }

    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Filter Option
extension TaskListViewModel {
    enum FilterOption: String, CaseIterable {
        case all       = "全部"
        case pending   = "待辦"
        case completed = "已完成"
        case overdue   = "已逾期"
    }
}
