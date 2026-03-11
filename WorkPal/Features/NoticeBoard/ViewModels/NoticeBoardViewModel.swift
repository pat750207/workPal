// NoticeBoardViewModel.swift
// WorkPal — Features/NoticeBoard/ViewModels
//
// 原始：NoticeBoardViewController 的 getNoticeBoards()
// ✅ UITableView.reloadData → @Published 自動更新

import Foundation

@MainActor
final class NoticeBoardViewModel: ObservableObject {

    @Published private(set) var noticeBoards: [NoticeBoardItem] = []
    @Published private(set) var isLoading = false

    private let jsonLoader: JSONLoaderProtocol

    init(jsonLoader: JSONLoaderProtocol = JSONLoader()) {
        self.jsonLoader = jsonLoader
    }

    func loadNoticeBoards() {
        isLoading = true
        noticeBoards = jsonLoader.loadNoticeBoards()
        isLoading = false
    }
}
