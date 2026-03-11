// SettingViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class SettingViewModelTests: XCTestCase {

    private var sut: SettingSwiftUIViewModel!
    private var mockState: MockPunchStateManager!

    override func setUp() async throws {
        try await super.setUp()
        mockState = MockPunchStateManager()
        mockState.storedWorkingHours = 9.0
        sut = SettingSwiftUIViewModel(stateManager: mockState)
    }

    override func tearDown() async throws {
        sut = nil
        mockState = nil
        try await super.tearDown()
    }

    // MARK: - Working Hours

    func test_addHours_shouldIncreaseByGap() {
        let before = sut.workingHours
        sut.addHours()
        XCTAssertEqual(sut.workingHours, before + 0.5)
    }

    func test_minusHours_shouldDecreaseByGap() {
        let before = sut.workingHours
        sut.minusHours()
        XCTAssertEqual(sut.workingHours, before - 0.5)
    }

    func test_addHours_atMax_shouldNotIncrease() {
        sut.workingHours = 24.0
        sut.addHours()
        XCTAssertEqual(sut.workingHours, 24.0)
    }

    func test_minusHours_atMin_shouldNotDecrease() {
        sut.workingHours = 0.5
        sut.minusHours()
        XCTAssertEqual(sut.workingHours, 0.5)
    }

    func test_isAddEnabled_belowMax_shouldBeTrue() {
        sut.workingHours = 10.0
        XCTAssertTrue(sut.isAddEnabled)
    }

    func test_isAddEnabled_atMax_shouldBeFalse() {
        sut.workingHours = 24.0
        XCTAssertFalse(sut.isAddEnabled)
    }

    // MARK: - displayHours

    func test_displayHours_wholeNumber_shouldShowInteger() {
        sut.workingHours = 9.0
        XCTAssertEqual(sut.displayHours, "9")
    }

    func test_displayHours_halfHour_shouldShowDecimal() {
        sut.workingHours = 9.5
        XCTAssertEqual(sut.displayHours, "9.5")
    }

    // MARK: - Auto Punch Out

    func test_autoPunchOut_toggle_shouldSaveToState() {
        sut.isAutoPunchOutOn = true
        XCTAssertTrue(mockState.storedAutoPunchOut)
    }

    // MARK: - saveSettings

    func test_saveSettings_shouldPersistWorkingHours() {
        sut.workingHours = 8.0
        sut.saveSettings()
        XCTAssertEqual(mockState.storedWorkingHours, 8.0)
    }
}
