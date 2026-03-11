// TaskItem.swift
// WorkPal — Features/TaskList/Models
//
// ✅ Value type (struct) — 對應 UIKit 中的 data model
// ✅ Identifiable — 對應 UITableView / UICollectionView 的 data source
// ✅ Codable — 對應 JSON 解析，取代手動 JSONSerialization

import Foundation

// MARK: - Model
struct TaskItem: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var createdAt: Date

    // MARK: - Init（方便 Unit Test 建立假資料）
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        priority: Priority = .medium,
        dueDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}

// MARK: - Priority
extension TaskItem {
    enum Priority: String, Codable, CaseIterable {
        case low    = "low"
        case medium = "medium"
        case high   = "high"

        var displayName: String {
            switch self {
            case .low:    return "低"
            case .medium: return "中"
            case .high:   return "高"
            }
        }

        var color: String {  // 使用 Color name 避免 import SwiftUI 進 Model
            switch self {
            case .low:    return "priorityLow"
            case .medium: return "priorityMedium"
            case .high:   return "priorityHigh"
            }
        }
    }
}

// MARK: - Computed Properties（純邏輯，方便測試）
extension TaskItem {
    var isOverdue: Bool {
        guard let due = dueDate else { return false }
        return !isCompleted && due.isOverdue
    }

    var statusSFSymbol: String {
        isCompleted ? "checkmark.circle.fill" : "circle"
    }
}
