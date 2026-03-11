// SettingSwiftUIViewModel.swift
// WorkPal — Features/Setting/ViewModels
//
// 原始：CompanyApp/ViewModel/SettingViewModel.swift
// ✅ 移除 UIKit.UIViewController import
// ✅ PushManagerDelegate → async callback
// ✅ lazy var isAddBtnEnabled → computed property

import Foundation
import UserNotifications

@MainActor
final class SettingSwiftUIViewModel: ObservableObject {

    // MARK: - Published State（原 @Published + lazy var）
    @Published var workingHours: Double
    @Published var isOffWorkPushOn: Bool = false
    @Published var isAutoPunchOutOn: Bool = false {
        didSet { stateManager.saveAutoPunchOutState(isOn: isAutoPunchOutOn) }
    }

    // MARK: - Computed（原 lazy var isAddBtnEnabled / isMinusBtnEnabled）
    let maxHours: Double = 24.0
    let minHours: Double = 0.5
    let gap: Double = 0.5

    var isAddEnabled: Bool { workingHours < maxHours }
    var isMinusEnabled: Bool { workingHours > minHours }

    var displayHours: String {
        let isInt = Int(workingHours * 10) % 10 == 0
        return isInt ? "\(Int(workingHours))" : "\(workingHours)"
    }

    // MARK: - Dependencies
    private let stateManager: PunchStateManagerProtocol

    init(stateManager: PunchStateManagerProtocol = PunchStateStore.shared) {
        self.stateManager = stateManager
        let saved = stateManager.getWorkingHours()
        self.workingHours = saved >= 0.5 ? saved : 9.0
        self.isAutoPunchOutOn = stateManager.getAutoPunchOutState()
    }

    // MARK: - Intents（原 IBAction add / minus）

    func addHours() {
        guard isAddEnabled else { return }
        workingHours += gap
    }

    func minusHours() {
        guard isMinusEnabled else { return }
        workingHours -= gap
    }

    // 原 viewWillDisappear → saveDataToUserDefault
    func saveSettings() {
        stateManager.saveWorkingHours(workingHours)

        if isOffWorkPushOn, let punchInTime = stateManager.getPunchInTime() {
            let interval = workingHours * 3600
            let suggestTime = punchInTime.addingTimeInterval(interval)
            PushManager.shared.createPunchOutPushNotification(on: suggestTime)

            if isAutoPunchOutOn {
                stateManager.savePunchInTime(punchInTime)
            }
        }
    }

    // 原 syncPushStatus
    func syncPushStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .denied:  self?.isOffWorkPushOn = false
                case .authorized: self?.isOffWorkPushOn = true
                default: break
                }
            }
        }
    }

    func togglePush() {
        PushManager.shared.checkStatus(on: Date())
    }
}
