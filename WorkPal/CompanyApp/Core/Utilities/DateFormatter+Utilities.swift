// DateFormatter+Utilities.swift
// WorkPal — Core/Utilities

import Foundation

extension DateFormatter {
    static let workpalDisplay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()

    static let workpalISO: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}

extension Date {
    var displayString: String {
        DateFormatter.workpalDisplay.string(from: self)
    }

    var isOverdue: Bool {
        self < Date()
    }
}
