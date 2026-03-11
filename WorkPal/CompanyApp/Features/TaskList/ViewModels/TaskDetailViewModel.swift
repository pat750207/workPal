// TaskDetailViewModel.swift
// WorkPal — Features/TaskList/ViewModels

import Foundation

@MainActor
final class TaskDetailViewModel: ObservableObject {

    // MARK: - Published State
    @Published var title: String
    @Published var description: String
    @Published var priority: TaskItem.Priority
    @Published var dueDate: Date?
    @Published var isCompleted: Bool
    @Published private(set) var isLoading = false
    @Published var errorMessage: NetworkError?
    @Published private(set) var isSaved = false

    // MARK: - Private
    private let originalTask: TaskItem
    private let service: TaskServiceProtocol

    // MARK: - Computed
    var hasChanges: Bool {
        title != originalTask.title ||
        description != originalTask.description ||
        priority != originalTask.priority ||
        dueDate != originalTask.dueDate
    }

    var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    init(task: TaskItem, service: TaskServiceProtocol) {
        self.originalTask = task
        self.service = service
        self.title = task.title
        self.description = task.description
        self.priority = task.priority
        self.dueDate = task.dueDate
        self.isCompleted = task.isCompleted
    }

    // MARK: - Intents
    func save() async {
        guard isValid else { return }
        isLoading = true
        defer { isLoading = false }

        var updated = originalTask
        updated.title = title.trimmingCharacters(in: .whitespaces)
        updated.description = description
        updated.priority = priority
        updated.dueDate = dueDate

        do {
            _ = try await service.updateTask(updated)
            isSaved = true
        } catch let error as NetworkError {
            errorMessage = error
        } catch {
            errorMessage = .unknown(error.localizedDescription)
        }
    }

    func resetChanges() {
        title = originalTask.title
        description = originalTask.description
        priority = originalTask.priority
        dueDate = originalTask.dueDate
    }
}
