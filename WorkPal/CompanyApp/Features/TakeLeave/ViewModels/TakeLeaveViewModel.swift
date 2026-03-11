// TakeLeaveViewModel.swift
// WorkPal — Features/TakeLeave/ViewModels
//
// 原始：TakeLeaveViewController 的業務邏輯
// ✅ Delegate（MyPickerDelegate）→ @Published binding
// ✅ UIDatePicker → DatePicker binding
// ✅ UITextView placeholder → @Published + prompt

import Foundation

@MainActor
final class TakeLeaveViewModel: ObservableObject {

    @Published var leaveRequest = LeaveRequest()
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    // MARK: - Computed（純邏輯，可單獨測試）
    var isFormValid: Bool {
        leaveRequest.endTime > leaveRequest.startTime
    }

    // MARK: - Intents（原 sendButtonClicked）
    func submitLeave() {
        guard isFormValid else {
            errorMessage = "Please fill in valid start and end times."
            showErrorAlert = true
            return
        }
        // 原本的 API 呼叫（目前註解）→ 直接成功
        showSuccessAlert = true
    }

    func resetForm() {
        leaveRequest = LeaveRequest()
    }
}
