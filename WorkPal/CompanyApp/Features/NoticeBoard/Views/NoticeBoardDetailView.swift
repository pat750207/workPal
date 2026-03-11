// NoticeBoardDetailView.swift
// WorkPal — Features/NoticeBoard/Views
//
// 原始：NoticeBoardDetailViewController.swift
// ✅ init(noticeBoardDetail:) → 直接傳入 notice
// ✅ @IBOutlet → View 直接讀取 model
// ✅ contentTextView.isEditable = false → Text（唯讀）

import SwiftUI

struct NoticeBoardDetailView: View {
    let notice: NoticeBoardItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 原 titleLabel
                Text(notice.title ?? "")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                // 原 dateLabel
                if let date = notice.date {
                    Text(date)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                Divider()

                // 原 contentTextView（isEditable = false）
                Text(notice.displayContent)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(6)
            }
            .padding()
        }
        .background(Color(red: 0.08, green: 0.08, blue: 0.08).ignoresSafeArea())
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NoticeBoardDetailView(
            notice: NoticeBoardItem(title: "Test Notice", content: "Content here\\nNew line", date: "2025-01-15")
        )
    }
    .preferredColorScheme(.dark)
}
