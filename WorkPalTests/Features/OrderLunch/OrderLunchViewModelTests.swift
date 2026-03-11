// OrderLunchViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class OrderLunchViewModelTests: XCTestCase {

    private var sut: OrderLunchViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = OrderLunchViewModel()
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_initialState_noSelection() {
        XCTAssertNil(sut.selectedItem)
        XCTAssertFalse(sut.hasSelection)
        XCTAssertFalse(sut.showAlert)
    }

    func test_selectItem_shouldUpdateSelection() {
        let item = sut.menuItems[0]
        sut.selectItem(item)
        XCTAssertEqual(sut.selectedItem?.id, item.id)
        XCTAssertTrue(sut.hasSelection)
    }

    func test_confirmOrder_noSelection_shouldShowError() {
        sut.confirmOrder()
        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertTitle, "No Selection")
    }

    func test_confirmOrder_withSelection_shouldShowSuccess() {
        sut.selectItem(sut.menuItems[0])
        sut.confirmOrder()
        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertTitle, "Order Successful")
        XCTAssertTrue(sut.alertMessage.contains(sut.menuItems[0].name))
    }
}
