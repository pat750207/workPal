// NoticeBoardViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class NoticeBoardViewModelTests: XCTestCase {

    private var sut: NoticeBoardViewModel!
    private var mockLoader: MockJSONLoader!

    override func setUp() async throws {
        try await super.setUp()
        mockLoader = MockJSONLoader()
        sut = NoticeBoardViewModel(jsonLoader: mockLoader)
    }

    override func tearDown() async throws {
        sut = nil
        mockLoader = nil
        try await super.tearDown()
    }

    func test_loadNoticeBoards_shouldPopulateArray() {
        mockLoader.mockNoticeBoards = [
            NoticeBoardItem(title: "Notice 1", content: "Content", date: "2025-01-01"),
            NoticeBoardItem(title: "Notice 2", content: nil, date: nil)
        ]
        sut = NoticeBoardViewModel(jsonLoader: mockLoader)
        sut.loadNoticeBoards()
        XCTAssertEqual(sut.noticeBoards.count, 2)
    }

    func test_loadNoticeBoards_emptyData_shouldReturnEmpty() {
        mockLoader.mockNoticeBoards = []
        sut = NoticeBoardViewModel(jsonLoader: mockLoader)
        sut.loadNoticeBoards()
        XCTAssertTrue(sut.noticeBoards.isEmpty)
    }
}
