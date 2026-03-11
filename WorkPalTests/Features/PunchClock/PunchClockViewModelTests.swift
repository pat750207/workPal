// PunchClockViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class PunchClockViewModelTests: XCTestCase {

    private var sut: PunchClockSwiftUIViewModel!
    private var mockState: MockPunchStateManager!
    private var mockData: MockDataManager!
    private var mockJSON: MockJSONLoader!

    override func setUp() async throws {
        try await super.setUp()
        mockState = MockPunchStateManager()
        mockData = MockDataManager()
        mockJSON = MockJSONLoader()
        sut = PunchClockSwiftUIViewModel(
            stateManager: mockState,
            dataManager: mockData,
            jsonLoader: mockJSON
        )
    }

    override func tearDown() async throws {
        sut = nil
        mockState = nil
        mockData = nil
        mockJSON = nil
        try await super.tearDown()
    }

    // MARK: - Initial State

    func test_init_noPreviousPunchIn_shouldNotBePunchedIn() {
        XCTAssertFalse(sut.isPunchedIn)
        XCTAssertTrue(sut.shouldShowCaption)
        XCTAssertFalse(sut.shouldShowCheckOutButton)
    }

    func test_init_withSavedPunchIn_shouldRestoreState() async throws {
        mockState.storedPunchInTime = Date()
        let vm = PunchClockSwiftUIViewModel(
            stateManager: mockState, dataManager: mockData, jsonLoader: mockJSON
        )
        XCTAssertTrue(vm.isPunchedIn)
        XCTAssertFalse(vm.shouldShowCaption)
    }

    func test_init_shouldLoadQuote() {
        XCTAssertEqual(sut.quoteText, "Test quote")
    }

    // MARK: - punchIn

    func test_punchIn_shouldSetPunchedIn() {
        sut.punchIn()
        XCTAssertTrue(sut.isPunchedIn)
        XCTAssertNotNil(sut.punchInTime)
        XCTAssertNotNil(mockState.storedPunchInTime)
    }

    func test_punchIn_alreadyPunchedIn_shouldDoNothing() {
        sut.punchIn()
        let firstTime = sut.punchInTime
        sut.punchIn()
        XCTAssertEqual(sut.punchInTime, firstTime)
    }

    // MARK: - punchOut

    func test_punchOut_afterPunchIn_shouldSetPunchedOut() {
        sut.punchIn()
        sut.punchOut()
        XCTAssertTrue(sut.isPunchedOut)
        XCTAssertNotNil(sut.punchOutTime)
        XCTAssertTrue(sut.showPunchOutCongrats)
    }

    func test_punchOut_shouldWriteRecord() {
        sut.punchIn()
        sut.punchOut()
        XCTAssertEqual(mockData.writtenRecords.count, 1)
    }

    func test_punchOut_withoutPunchIn_shouldDoNothing() {
        sut.punchOut()
        XCTAssertFalse(sut.isPunchedOut)
    }

    // MARK: - resetAfterPunchOut

    func test_resetAfterPunchOut_shouldClearAllState() {
        sut.punchIn()
        sut.punchOut()
        sut.resetAfterPunchOut()
        XCTAssertFalse(sut.isPunchedIn)
        XCTAssertFalse(sut.isPunchedOut)
        XCTAssertNil(sut.punchInTime)
        XCTAssertNil(sut.punchOutTime)
    }

    // MARK: - Computed

    func test_shouldShowCheckOutButton_punchedInNotOut_shouldBeTrue() {
        sut.punchIn()
        XCTAssertTrue(sut.shouldShowCheckOutButton)
    }

    func test_workingHourStr_default9Hours() {
        XCTAssertEqual(sut.workingHourStr, "Work hard 9 hours")
    }
}
