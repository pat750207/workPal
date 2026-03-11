// TakeLeaveViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class TakeLeaveViewModelTests: XCTestCase {

    private var sut: TakeLeaveViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = TakeLeaveViewModel()
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_isFormValid_endTimeAfterStart_shouldBeTrue() {
        sut.leaveRequest.startTime = Date()
        sut.leaveRequest.endTime = Date().addingTimeInterval(3600)
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_endTimeBeforeStart_shouldBeFalse() {
        sut.leaveRequest.startTime = Date()
        sut.leaveRequest.endTime = Date().addingTimeInterval(-3600)
        XCTAssertFalse(sut.isFormValid)
    }

    func test_submitLeave_invalidForm_shouldShowError() {
        sut.leaveRequest.startTime = Date()
        sut.leaveRequest.endTime = Date().addingTimeInterval(-3600)
        sut.submitLeave()
        XCTAssertTrue(sut.showErrorAlert)
    }

    func test_submitLeave_validForm_shouldShowSuccess() {
        sut.leaveRequest.startTime = Date()
        sut.leaveRequest.endTime = Date().addingTimeInterval(3600)
        sut.leaveRequest.reason = "Test reason"
        sut.submitLeave()
        XCTAssertTrue(sut.showSuccessAlert)
    }

    func test_resetForm_shouldClearAll() {
        sut.leaveRequest.reason = "Some reason"
        sut.leaveRequest.leaveType = .annualLeave
        sut.resetForm()
        XCTAssertEqual(sut.leaveRequest.reason, "")
        XCTAssertEqual(sut.leaveRequest.leaveType, .sickLeave)
    }
}
