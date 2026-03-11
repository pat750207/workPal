// NoticeBoardItem.swift
// WorkPal — Features/NoticeBoard/Models
//
// 原始：CompanyApp/Model/NoticeBoard.swift (struct NoticeBoard: Codable)
// ✅ 加入 Identifiable（List 需要）、Hashable（NavigationLink(value:) 需要）

import Foundation

struct NoticeBoardItem: Codable, Identifiable, Hashable {
    var id: String { title ?? UUID().uuidString }
    let title: String?
    let content: String?
    let date: String?

    /// 處理 content 中的 \\n → 換行
    var displayContent: String {
        content?.replacingOccurrences(of: "\\n", with: "\n") ?? ""
    }
}

struct NoticeBoardResponse: Codable {
    let noticeBoards: [NoticeBoardItem]
}
