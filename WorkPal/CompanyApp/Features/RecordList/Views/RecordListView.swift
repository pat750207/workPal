// RecordListView.swift
// WorkPal — Features/RecordList/Views
//
// 原始：RecordListViewController.swift
// ✅ UITableView + RecordListTableViewCell → List + Row
// ✅ viewWillAppear → .task

import SwiftUI

struct RecordListView: View {

    @ObservedObject var viewModel: RecordListViewModel

    var body: some View {
        Group {
            if viewModel.records.isEmpty {
                ContentUnavailableView("No Records", systemImage: "clock.badge.questionmark",
                                       description: Text("No punch records for this month"))
            } else {
                recordList
            }
        }
        .navigationTitle("Records")
        // 原 viewWillAppear → fetchData()
        .task { await viewModel.fetchRecords() }
    }

    private var recordList: some View {
        List(viewModel.records) { record in
            RecordRow(record: record)
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Row（原 RecordListTableViewCell）
struct RecordRow: View {
    let record: PunchRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundStyle(.green)
                Text("In: \(record.inTimeString)")
                    .font(.subheadline)
            }
            HStack {
                Image(systemName: "arrow.left.circle.fill")
                    .foregroundStyle(.orange)
                Text("Out: \(record.outTimeString)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        RecordListView(viewModel: RecordListViewModel())
    }
    .preferredColorScheme(.dark)
}
