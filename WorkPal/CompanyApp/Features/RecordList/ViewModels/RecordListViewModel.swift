// RecordListViewModel.swift
// WorkPal — Features/RecordList/ViewModels
//
// 原始：RecordListViewController 的業務邏輯
// ✅ 移除 UIKit 依賴
// ✅ 依賴注入 DataManagerProtocol

import Foundation

@MainActor
final class RecordListViewModel: ObservableObject {

    @Published private(set) var records: [PunchRecord] = []
    @Published private(set) var isLoading = false

    var monthString: String = Date().toString(dateFormat: .month)

    private let dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol = CompanyDataManger.shared) {
        self.dataManager = dataManager
    }

    func fetchRecords() async {
        isLoading = true
        defer { isLoading = false }
        records = await dataManager.fetchRecords(month: monthString)
    }
}
