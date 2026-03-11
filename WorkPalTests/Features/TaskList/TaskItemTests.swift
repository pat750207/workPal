// TaskItemTests.swift
// WorkPalTests
//
// ✅ Model 層純邏輯測試（不依賴任何 UI 框架）

import XCTest
@testable import WorkPal

final class TaskItemTests: XCTestCase {

    // MARK: - isOverdue Tests

    func test_isOverdue_withPastDueDateAndIncomplete_shouldBeTrue() {
        // Given
        let task = TaskItem(
            title: "Overdue Task",
            isCompleted: false,
            dueDate: Date().addingTimeInterval(-3600) // 1 小時前
        )

        // Then
        XCTAssertTrue(task.isOverdue)
    }

    func test_isOverdue_withPastDueDateButCompleted_shouldBeFalse() {
        // Given
        let task = TaskItem(
            title: "Done Task",
            isCompleted: true,
            dueDate: Date().addingTimeInterval(-3600)
        )

        // Then
        XCTAssertFalse(task.isOverdue)
    }

    func test_isOverdue_withFutureDueDate_shouldBeFalse() {
        // Given
        let task = TaskItem(
            title: "Future Task",
            dueDate: Date().addingTimeInterval(86400)
        )

        // Then
        XCTAssertFalse(task.isOverdue)
    }

    func test_isOverdue_withNoDueDate_shouldBeFalse() {
        // Given
        let task = TaskItem(title: "No Due Date")

        // Then
        XCTAssertFalse(task.isOverdue)
    }

    // MARK: - statusSFSymbol Tests

    func test_statusSFSymbol_whenCompleted_shouldBeCheckmark() {
        let task = TaskItem(title: "Done", isCompleted: true)
        XCTAssertEqual(task.statusSFSymbol, "checkmark.circle.fill")
    }

    func test_statusSFSymbol_whenPending_shouldBeCircle() {
        let task = TaskItem(title: "Pending", isCompleted: false)
        XCTAssertEqual(task.statusSFSymbol, "circle")
    }

    // MARK: - Codable Tests

    func test_taskItem_codable_shouldEncodeAndDecodeCorrectly() throws {
        // Given
        let original = TaskItem(
            id: "test-123",
            title: "Codable Test",
            description: "Testing encode/decode",
            isCompleted: false,
            priority: .high
        )

        // When
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TaskItem.self, from: encoded)

        // Then
        XCTAssertEqual(original.id, decoded.id)
        XCTAssertEqual(original.title, decoded.title)
        XCTAssertEqual(original.priority, decoded.priority)
    }

    // MARK: - Equatable Tests

    func test_taskItem_equality_sameId_shouldBeEqual() {
        let task1 = TaskItem(id: "same-id", title: "Task A")
        let task2 = TaskItem(id: "same-id", title: "Task B")
        XCTAssertEqual(task1, task2)
    }

    func test_taskItem_equality_differentId_shouldNotBeEqual() {
        let task1 = TaskItem(id: "id-1", title: "Task")
        let task2 = TaskItem(id: "id-2", title: "Task")
        XCTAssertNotEqual(task1, task2)
    }
}
