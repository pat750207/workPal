// CreateTaskView.swift
// WorkPal — Features/TaskList/Views
//
// UIKit 對應：UIViewController presented modally
// ✅ Delegate 回傳改為直接呼叫父 ViewModel

import SwiftUI

struct CreateTaskView: View {

    @ObservedObject var viewModel: TaskListViewModel
    @Environment(\.dismiss) private var dismiss

    // 本地表單狀態（只在此 View 生命週期內有效）
    @State private var title = ""
    @State private var description = ""
    @State private var priority: TaskItem.Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date().addingTimeInterval(86400)
    @State private var isSaving = false

    private var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("標題 *") {
                    TextField("輸入任務標題", text: $title)
                        .autocorrectionDisabled()
                }

                Section("描述") {
                    TextEditor(text: $description)
                        .frame(minHeight: 80)
                }

                Section("優先度") {
                    Picker("優先度", selection: $priority) {
                        ForEach(TaskItem.Priority.allCases, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Toggle("設定截止日期", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("截止日期", selection: $dueDate, in: Date()...,
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("新增任務")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") {
                        Task {
                            isSaving = true
                            await viewModel.createTask(
                                title: title,
                                description: description,
                                priority: priority,
                                dueDate: hasDueDate ? dueDate : nil
                            )
                            isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(!isValid || isSaving)
                }
            }
            .loadingOverlay(isLoading: isSaving)
        }
    }
}

#Preview {
    CreateTaskView(viewModel: TaskListViewModel(service: MockTaskService()))
}
