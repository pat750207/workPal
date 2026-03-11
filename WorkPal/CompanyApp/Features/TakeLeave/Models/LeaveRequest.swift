// LeaveRequest.swift
// WorkPal — Features/TakeLeave/Models

import Foundation

// 原始：TakeLeaveViewController 中的 LeaveType enum（已從 MyPicker.swift 遷移至此）
// MyPicker.swift 中的原始版本已改名為 LegacyLeaveType 避免衝突
enum LeaveType: String, CaseIterable, Identifiable {
    case sickLeave = "Sick Leave"
    case personalLeave = "Personal Leave"
    case annualLeave = "Annual Leave"
    case compensatoryLeave = "Compensatory Leave"
    case maternityLeave = "Maternity Leave"
    case bereavementLeave = "Bereavement Leave"

    var id: String { rawValue }
    var title: String { rawValue }
}

struct LeaveRequest: Equatable {
    var leaveType: LeaveType = .sickLeave
    var startTime: Date = Date()
    var endTime: Date = Date()
    var reason: String = ""

    var isValid: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty && endTime > startTime
    }
}
