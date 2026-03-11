// PunchStateManager.swift
// WorkPal — Core/Managers
//
// 原始：UserDefaultManager（static 方法）
// ✅ Protocol 化，方便 Mock 注入

import Foundation

// MARK: - Protocol
protocol PunchStateManagerProtocol {
    func getPunchInTime() -> Date?
    func getPunchOutTime() -> Date?
    func savePunchInTime(_ date: Date)
    func savePunchOutTime(_ date: Date)
    func removePunchInTime()
    func getWorkingHours() -> Double
    func saveWorkingHours(_ hours: Double)
    func getAutoPunchOutState() -> Bool
    func saveAutoPunchOutState(isOn: Bool)
}

// MARK: - 既有 UserDefaultManager 轉接
final class PunchStateStore: PunchStateManagerProtocol {

    static let shared = PunchStateStore()
    private init() {}

    func getPunchInTime() -> Date? { UserDefaultManager.getPunchInTime() }
    func getPunchOutTime() -> Date? { UserDefaultManager.getPunchOutTime() }
    func savePunchInTime(_ date: Date) { UserDefaultManager.savePunchInTime(date) }
    func savePunchOutTime(_ date: Date) { UserDefaultManager.savePunchOutTime(date) }
    func removePunchInTime() { UserDefaultManager.removePunchInTime() }
    func getWorkingHours() -> Double { UserDefaultManager.getWorkingHours() }
    func saveWorkingHours(_ hours: Double) { UserDefaultManager.saveWorkingHours(hours) }
    func getAutoPunchOutState() -> Bool { UserDefaultManager.getAutoPunchOutState() }
    func saveAutoPunchOutState(isOn: Bool) { UserDefaultManager.saveAutoPunchOutState(isOn: isOn) }
}

// MARK: - Mock（Unit Test 用）
final class MockPunchStateManager: PunchStateManagerProtocol {
    var storedPunchInTime: Date?
    var storedPunchOutTime: Date?
    var storedWorkingHours: Double = 9.0
    var storedAutoPunchOut: Bool = false

    func getPunchInTime() -> Date? { storedPunchInTime }
    func getPunchOutTime() -> Date? { storedPunchOutTime }
    func savePunchInTime(_ date: Date) { storedPunchInTime = date }
    func savePunchOutTime(_ date: Date) { storedPunchOutTime = date }
    func removePunchInTime() { storedPunchInTime = nil; storedPunchOutTime = nil }
    func getWorkingHours() -> Double { storedWorkingHours }
    func saveWorkingHours(_ hours: Double) { storedWorkingHours = hours }
    func getAutoPunchOutState() -> Bool { storedAutoPunchOut }
    func saveAutoPunchOutState(isOn: Bool) { storedAutoPunchOut = isOn }
}
