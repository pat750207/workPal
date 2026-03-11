// JSONLoader.swift
// WorkPal — Core/Managers
//
// 原始：CompanyApp/Manager/JSONUtils.swift（全域函式）
// ✅ 改為 Protocol 化的 struct

import Foundation

protocol JSONLoaderProtocol {
    func loadQuote() -> String?
    func loadNoticeBoards() -> [NoticeBoardItem]
}

struct JSONLoader: JSONLoaderProtocol {

    func loadQuote() -> String? {
        guard let data = readLocalJSON(forName: "Quotes") else { return nil }
        let decoded = try? JSONDecoder().decode(QuoteResponse.self, from: data)
        return decoded?.quotes.randomElement()?.quote
    }

    func loadNoticeBoards() -> [NoticeBoardItem] {
        guard let data = readLocalJSON(forName: "NoticeBoards") else { return [] }
        let decoded = try? JSONDecoder().decode(NoticeBoardResponse.self, from: data)
        return decoded?.noticeBoards ?? []
    }

    private func readLocalJSON(forName name: String) -> Data? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}

// MARK: - Mock
struct MockJSONLoader: JSONLoaderProtocol {
    var mockQuote: String? = "Test quote"
    var mockNoticeBoards: [NoticeBoardItem] = []

    func loadQuote() -> String? { mockQuote }
    func loadNoticeBoards() -> [NoticeBoardItem] { mockNoticeBoards }
}
