// PunchClockSwiftUIViewModel.swift
// WorkPal — Features/PunchClock/ViewModels
//
// 原始：CompanyApp/ViewModel/PunchClockViewModel.swift
// ✅ 移除所有 UIKit 依賴（UILabel, UIButton, UIImpactFeedbackGenerator）
// ✅ captionLabel / checkInButton / checkOutButton → @Published 狀態
// ✅ Combine Timer → async/await + Task
// ✅ UIView.animate → withAnimation（在 View 端處理）

import Foundation

@MainActor
final class PunchClockSwiftUIViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var dateStr: String = ""
    @Published private(set) var weekDayStr: String = ""
    @Published private(set) var currentTimeStr: String = ""
    @Published private(set) var quoteText: String = "Life has no limitations, except the ones you make."

    @Published var isPunchedIn: Bool = false
    @Published var isPunchedOut: Bool = false
    @Published var showPunchOutCongrats = false

    @Published private(set) var punchInTime: Date?
    @Published private(set) var punchOutTime: Date?

    // MARK: - Computed
    var punchInTimeStr: String? { punchInTime?.toString(dateFormat: .hourMinute) }
    var punchOutTimeStr: String? { punchOutTime?.toString(dateFormat: .hourMinute) }

    var workingHourStr: String {
        let hours = workingHour
        let isInt = Int(hours * 10) % 10 == 0
        return isInt ? "Work hard \(Int(hours)) hours" : "Work hard \(hours) hours"
    }

    var shouldShowCaption: Bool { !isPunchedIn }
    var shouldShowCheckOutButton: Bool { isPunchedIn && !isPunchedOut }

    private var workingHour: Double {
        let saved = stateManager.getWorkingHours()
        return saved > 0 ? saved : 9.0
    }

    // MARK: - Dependencies
    private let stateManager: PunchStateManagerProtocol
    private let dataManager: DataManagerProtocol
    private let jsonLoader: JSONLoaderProtocol
    private var timerTask: Task<Void, Never>?

    init(
        stateManager: PunchStateManagerProtocol = PunchStateStore.shared,
        dataManager: DataManagerProtocol = CompanyDataManger.shared,
        jsonLoader: JSONLoaderProtocol = JSONLoader()
    ) {
        self.stateManager = stateManager
        self.dataManager = dataManager
        self.jsonLoader = jsonLoader

        updateDateStrings()
        restorePunchInState()
        loadQuote()
        startTimer()
    }

    deinit {
        timerTask?.cancel()
    }

    // MARK: - Intents（原 @objc checkIn / checkOut）

    func punchIn() {
        guard !isPunchedIn else { return }
        isPunchedIn = true
        punchInTime = Date()
        stateManager.savePunchInTime(punchInTime!)
        triggerHaptic()
    }

    func punchOut() {
        guard isPunchedIn, !isPunchedOut else { return }

        if isAutoPunchOut(), let savedOut = stateManager.getPunchOutTime() {
            punchOutTime = savedOut
        } else {
            punchOutTime = Date()
        }

        stateManager.removePunchInTime()

        // 寫入紀錄
        if let month = punchInTime?.toString(dateFormat: .month) {
            dataManager.writeRecord(month: month, inTime: punchInTime, outTime: punchOutTime)
        }

        isPunchedOut = true
        triggerHaptic()
        showPunchOutCongrats = true
    }

    func resetAfterPunchOut() {
        isPunchedIn = false
        isPunchedOut = false
        punchInTime = nil
        punchOutTime = nil
    }

    func checkAutoPunchOut() {
        if isAutoPunchOut() {
            punchOut()
        }
    }

    // MARK: - Private

    private func restorePunchInState() {
        if let savedTime = stateManager.getPunchInTime() {
            punchInTime = savedTime
            isPunchedIn = true
        }
    }

    private func updateDateStrings() {
        let now = Date()
        dateStr = now.toString(dateFormat: .yearMonthDate)
        weekDayStr = now.toString(dateFormat: .weekday)
        currentTimeStr = now.toString(dateFormat: .hourMinute)
    }

    private func startTimer() {
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                self?.currentTimeStr = Date().toString(dateFormat: .hourMinute)
            }
        }
    }

    private func loadQuote() {
        if let quote = jsonLoader.loadQuote() {
            quoteText = quote
        }
    }

    private func isAutoPunchOut() -> Bool {
        guard let outTime = stateManager.getPunchOutTime() else { return false }
        return stateManager.getAutoPunchOutState() && outTime <= Date()
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
}

// 補上 iOS haptic 的 import
#if os(iOS)
import UIKit
#endif
