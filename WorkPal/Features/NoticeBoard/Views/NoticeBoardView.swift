// NoticeBoardView.swift
// WorkPal — Features/NoticeBoard/Views
//
// 原始：NoticeBoardViewController.swift
// ✅ UITableView → List
// ✅ UITableViewDelegate/DataSource → ForEach + NavigationLink
// ✅ didSelectRowAt → NavigationLink(value:) + navigationDestination
// ✅ UINib register → 不需要

import SwiftUI

struct NoticeBoardView: View {

    @ObservedObject var viewModel: NoticeBoardViewModel

    var body: some View {
        Group {
            if viewModel.noticeBoards.isEmpty && viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.noticeBoards.isEmpty {
                ContentUnavailableView("No Notices", systemImage: "megaphone",
                                       description: Text("No announcements yet"))
            } else {
                noticeList
            }
        }
        .navigationTitle("Notices")
        // 原 viewDidLoad → getNoticeBoards()
        .task { viewModel.loadNoticeBoards() }
    }

    private var noticeList: some View {
        List(viewModel.noticeBoards) { notice in
            // 原 didSelectRowAt → push NoticeBoardDetailViewController
            NavigationLink {
                NoticeBoardDetailView(notice: notice)
            } label: {
                NoticeBoardRow(notice: notice)
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Row（原 NoticeBoardCell）
struct NoticeBoardRow: View {
    let notice: NoticeBoardItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(notice.title ?? "")
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(2)

            if let date = notice.date {
                Text(date)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            if let content = notice.content, !content.isEmpty {
                Text(content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        NoticeBoardView(viewModel: NoticeBoardViewModel())
    }
    .preferredColorScheme(.dark)
}
