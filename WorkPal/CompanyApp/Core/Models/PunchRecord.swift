// PunchRecord.swift
// WorkPal — Core/Models
//
// 原始：CompanyApp/Model/TimeRecord.swift
// ✅ 加入 Identifiable（List 需要）
// ✅ 保留 Codable

import Foundation

struct PunchRecord: Codable, Identifiable, Equatable {
    var id: String { "\(inTime?.timeIntervalSince1970 ?? 0)" }

    var inTime: Date?
    var outTime: Date?

    init(inTime: Date? = nil, outTime: Date? = nil) {
        self.inTime = inTime
        self.outTime = outTime
    }

    var inTimeString: String {
        inTime?.toString(dateFormat: .all) ?? "Not Punch in yet"
    }

    var outTimeString: String {
        outTime?.toString(dateFormat: .all) ?? "Not Punch out yet"
    }
}
