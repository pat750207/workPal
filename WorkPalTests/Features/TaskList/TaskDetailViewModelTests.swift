// TaskDetailViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class TaskDetailViewModelTests: XCTestCase {

    private var sut: TaskDetailViewModel!
    private var mockService: MockTaskService!
    private let baseTask = TaskItem(id: "detail-1", title: "Original Title", priority: .low)

    override func setUp() async throws {
        try await super.setUp()
        mockService = MockTaskService()
        sut = TaskDetailViewModel(task: baseTask, service: mockService)
    }

    override func tearDown() async throws {
        sut = nil
        mockService = nil
        try await super.tearDown()
    }

    // MARK: - Initial State

    func test_init_shouldPreFillFieldsFromTask() {
        XCTAssertEqual(sut.title, baseTask.title)
        XCTAssertEqual(sut.priority, baseTask.priority)
        XCTAssertFalse(sut.isSaved)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - hasChanges

    func test_hasChanges_noChange_shouldBeFalse() {
        XCTAssertFalse(sut.hasChanges)
    }

    func test_hasChanges_afterTitleChange_shouldBeTrue() {
        sut.title = "Changed Title"
        XCTAssertTrue(sut.hasChanges)
    }

    func test_hasChanges_afterPriorityChange_shouldBeTrue() {
        sut.priority = .high
        XCTAssertTrue(sut.hasChanges)
    }

    // MARK: - isValid

    func test_isValid_withEmptyTitle_shouldBeFalse() {
        sut.title = ""
        XCTAssertFalse(sut.isValid)
    }

    func test_isValid_withWhitespaceTitle_shouldBeFalse() {
        sut.title = "   "
        XCTAssertFalse(sut.isValid)
    }

    func test_isValid_withValidTitle_shouldBeTrue() {
        sut.title = "Valid Title"
        XCTAssertTrue(sut.isValid)
    }

    // MARK: - save

    func test_save_success_shouldSetIsSavedTrue() async {
        // Given
        sut.title = "Updated Title"

        // When
        await sut.save()

        // Then
        XCTAssertTrue(sut.isSaved)
        XCTAssertNil(sut.errorMessage)
    }

    func test_save_failure_shouldSetErrorMessage() async {
        // Given
        sut.title = "Updated Title"
        mockService.shouldThrowError = true
        mockService.mockError = .serverError(statusCode: 422)

        // When
        await sut.save()

        // Then
        XCTAssertFalse(sut.isSaved)
        XCTAssertEqual(sut.errorMessage, .serverError(statusCode: 422))
    }

    // MARK: - resetChanges

    func test_resetChanges_shouldRestoreOriginalValues() {
        // Given
        sut.title = "Changed"
        sut.priority = .high

        // When
        sut.resetChanges()

        // Then
        XCTAssertEqual(sut.title, baseTask.title)
        XCTAssertEqual(sut.priority, baseTask.priority)
        XCTAssertFalse(sut.hasChanges)
    }
}
