// DataManagerProtocol.swift
// WorkPal — Core/Managers
//
// 原始：CompanyDataManger（callback-based）
// ✅ Protocol 化，方便 Mock 注入
// ✅ 改為 async/await

import Foundation

// MARK: - Protocol
protocol DataManagerProtocol {
    func writeRecord(month: String, inTime: Date?, outTime: Date?)
    func fetchRecords(month: String) async -> [PunchRecord]
    func deleteCache(month: String)
}

// MARK: - 既有 CompanyDataManger 轉接
extension CompanyDataManger: DataManagerProtocol {

    func writeRecord(month: String, inTime: Date?, outTime: Date?) {
        writeData(month: month, in: inTime, out: outTime)
    }

    func fetchRecords(month: String) async -> [PunchRecord] {
        await withCheckedContinuation { continuation in
            var result: [PunchRecord] = []
            // 轉換 TimeRecord → PunchRecord
            fetch(month: month) { timeRecords in
                result = timeRecords.map { PunchRecord(inTime: $0.inTime, outTime: $0.outTime) }
            }
            continuation.resume(returning: result)
        }
    }
}

// MARK: - Mock（Unit Test 用）
final class MockDataManager: DataManagerProtocol {
    var mockRecords: [PunchRecord] = []
    var writtenRecords: [(month: String, inTime: Date?, outTime: Date?)] = []

    func writeRecord(month: String, inTime: Date?, outTime: Date?) {
        writtenRecords.append((month, inTime, outTime))
    }

    func fetchRecords(month: String) async -> [PunchRecord] {
        mockRecords
    }

    func deleteCache(month: String) {}
}
