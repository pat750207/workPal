//
//  NoticeBoard.swift
//  iOS-188Asia
//
//  Created by Pat Chang (XN-188Asia) on 2025/1/21.
//

struct NoticeBoard: Codable {
    
    let title: String?
    let content: String?
    let date: String?
}

struct NoticeBoards: Codable {
    let noticeBoards: [NoticeBoard]
}

