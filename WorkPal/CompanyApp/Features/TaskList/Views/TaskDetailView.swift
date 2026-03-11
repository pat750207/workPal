// TaskDetailView.swift
// WorkPal — Features/TaskList/Views
//
// UIKit 對應：TaskDetailViewController
// ✅ Delegate → Binding / Closure
// ✅ viewWillAppear 資料預填 → init() 直接設定

import SwiftUI

struct TaskDetailView: View {

    // MARK: - UIKit 對應：依賴注入，取代 prepare(for:sender:)
    @StateObject private var viewModel: TaskDetailViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - 使用 AppContainer 建立 ViewModel
    init(task: TaskItem) {
        // 注意：此處應透過環境變數傳入 AppContainer，此處簡化示意
        _viewModel = StateObject(
            wrappedValue: TaskDetailViewModel(
                task: task,
                service: MockTaskService()  // 實際使用時替換為注入的 Service
            )
        )
    }

    var body: some View {
        Form {
            // 標題
            Section("標題") {
                TextField("輸入任務標題", text: $viewModel.title)
                    .autocorrectionDisabled()
            }

            // 描述
            Section("描述") {
                TextEditor(text: $viewModel.description)
                    .frame(minHeight: 80)
            }

            // 優先度（UIKit 對應：UISegmentedControl / UIPickerView）
            Section("優先度") {
                Picker("優先度", selection: $viewModel.priority) {
                    ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                        Text(priority.displayName).tag(priority)
                    }
                }
                .pickerStyle(.segmented)
            }

            // 截止日期（UIKit 對應：UIDatePicker）
            Section("截止日期") {
                Toggle("設定截止日期", isOn: Binding(
                    get: { viewModel.dueDate != nil },
                    set: { hasDate in
                        viewModel.dueDate = hasDate ? Date().addingTimeInterval(86400) : nil
                    }
                ))
                if let dueDate = viewModel.dueDate {
                    DatePicker(
                        "日期",
                        selection: Binding(
                            get: { dueDate },
                            set: { viewModel.dueDate = $0 }
                        ),
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
        }
        .navigationTitle("編輯任務")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") {
                    viewModel.resetChanges()
                    dismiss()
                }
                .disabled(!viewModel.hasChanges)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("儲存") {
                    Task { await viewModel.save() }
                }
                .disabled(!viewModel.isValid || !viewModel.hasChanges)
            }
        }
        // UIKit 對應：viewWillDisappear dismiss 的通知
        .onChange(of: viewModel.isSaved) { _, saved in
            if saved { dismiss() }
        }
        .errorAlert(error: $viewModel.errorMessage)
        .loadingOverlay(isLoading: viewModel.isLoading)
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: TaskItem.mocks[0])
    }
}
