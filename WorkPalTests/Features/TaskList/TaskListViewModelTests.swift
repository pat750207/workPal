// TaskListViewModelTests.swift
// WorkPalTests
//
// ✅ ViewModel 完全可測，因為：
//   1. 依賴 Protocol（TaskServiceProtocol），可注入 Mock
//   2. 業務邏輯集中在 ViewModel，不依賴 UIKit
//   3. 所有狀態是 @Published，可直接驗證

import XCTest
@testable import WorkPal

@MainActor
final class TaskListViewModelTests: XCTestCase {

    // MARK: - Properties
    private var sut: TaskListViewModel!        // System Under Test
    private var mockService: MockTaskService!

    // MARK: - Setup / Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockService = MockTaskService()
        sut = TaskListViewModel(service: mockService)
    }

    override func tearDown() async throws {
        sut = nil
        mockService = nil
        try await super.tearDown()
    }

    // MARK: - loadTasks Tests

    func test_loadTasks_success_shouldUpdateTasksArray() async {
        // Given
        mockService.mockTasks = [
            TaskItem(title: "Task A"),
            TaskItem(title: "Task B")
        ]

        // When
        await sut.loadTasks()

        // Then
        XCTAssertEqual(sut.tasks.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadTasks_failure_shouldSetErrorMessage() async {
        // Given
        mockService.shouldThrowError = true
        mockService.mockError = .serverError(statusCode: 500)

        // When
        await sut.loadTasks()

        // Then
        XCTAssertTrue(sut.tasks.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, .serverError(statusCode: 500))
    }

    func test_loadTasks_shouldSetIsLoadingDuringFetch() async {
        // Given: 初始狀態
        XCTAssertFalse(sut.isLoading)

        // When
        await sut.loadTasks()

        // Then: 完成後應為 false
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - filteredTasks Tests

    func test_filteredTasks_withSearchText_shouldFilterByTitle() async {
        // Given
        mockService.mockTasks = [
            TaskItem(title: "設計 UI"),
            TaskItem(title: "撰寫測試"),
            TaskItem(title: "設計資料庫")
        ]
        await sut.loadTasks()

        // When
        sut.searchText = "設計"

        // Then
        XCTAssertEqual(sut.filteredTasks.count, 2)
    }

    func test_filteredTasks_filterCompleted_shouldOnlyReturnCompleted() async {
        // Given
        mockService.mockTasks = [
            TaskItem(title: "待辦", isCompleted: false),
            TaskItem(title: "已完成", isCompleted: true)
        ]
        await sut.loadTasks()

        // When
        sut.selectedFilter = .completed

        // Then
        XCTAssertEqual(sut.filteredTasks.count, 1)
        XCTAssertEqual(sut.filteredTasks.first?.title, "已完成")
    }

    func test_filteredTasks_filterPending_shouldOnlyReturnPending() async {
        // Given
        mockService.mockTasks = [
            TaskItem(title: "待辦"),
            TaskItem(title: "已完成", isCompleted: true),
            TaskItem(title: "待辦2")
        ]
        await sut.loadTasks()

        // When
        sut.selectedFilter = .pending

        // Then
        XCTAssertEqual(sut.filteredTasks.count, 2)
    }

    // MARK: - toggleComplete Tests

    func test_toggleComplete_shouldFlipCompletedState() async {
        // Given
        let task = TaskItem(id: "1", title: "Test", isCompleted: false)
        mockService.mockTasks = [task]
        await sut.loadTasks()

        // When
        await sut.toggleComplete(task: task)

        // Then
        XCTAssertEqual(sut.tasks.first?.isCompleted, true)
    }

    func test_toggleComplete_failure_shouldSetError() async {
        // Given
        let task = TaskItem(id: "1", title: "Test")
        mockService.mockTasks = [task]
        await sut.loadTasks()
        mockService.shouldThrowError = true

        // When
        await sut.toggleComplete(task: task)

        // Then
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - deleteTask Tests

    func test_deleteTask_shouldRemoveFromArray() async {
        // Given
        let task = TaskItem(id: "1", title: "Delete me")
        mockService.mockTasks = [task]
        await sut.loadTasks()
        XCTAssertEqual(sut.tasks.count, 1)

        // When
        await sut.deleteTask(task)

        // Then
        XCTAssertTrue(sut.tasks.isEmpty)
    }

    // MARK: - createTask Tests

    func test_createTask_shouldInsertAtFront() async {
        // Given
        mockService.mockTasks = [TaskItem(title: "Existing")]
        await sut.loadTasks()

        // When
        await sut.createTask(title: "New Task", description: "", priority: .high, dueDate: nil)

        // Then
        XCTAssertEqual(sut.tasks.count, 2)
        XCTAssertEqual(sut.tasks.first?.title, "New Task")
    }

    // MARK: - Stats Tests

    func test_pendingCount_shouldCountOnlyIncomplete() async {
        // Given
        mockService.mockTasks = [
            TaskItem(title: "A", isCompleted: false),
            TaskItem(title: "B", isCompleted: true),
            TaskItem(title: "C", isCompleted: false)
        ]
        await sut.loadTasks()

        // Then
        XCTAssertEqual(sut.pendingCount, 2)
        XCTAssertEqual(sut.completedCount, 1)
    }

    // MARK: - clearError Tests

    func test_clearError_shouldResetErrorMessage() async {
        // Given
        mockService.shouldThrowError = true
        await sut.loadTasks()
        XCTAssertNotNil(sut.errorMessage)

        // When
        sut.clearError()

        // Then
        XCTAssertNil(sut.errorMessage)
    }
}
