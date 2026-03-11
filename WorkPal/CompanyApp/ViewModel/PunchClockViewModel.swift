//
//  PunchClockViewModel.swift
//  PunchClock
//

import Combine
import Foundation
import UIKit

protocol AutoPunchOutDelegate: AnyObject {
  func autoPunchOutDelegate(functionIsOn: Bool)
}

class PunchClockViewModel {

  private let dataManager = CompanyDataManger.shared
  var timerSubscriber: AnyCancellable?
  var cancellable = Set<AnyCancellable>()

  private weak var pushManager = PushManager.shared

  var isOffWorkPushOn = false

  @Published var isPunchIn: Bool = false {
    didSet {
      if isPunchIn, punchInTime == nil {
        punchInTime = Date()
        UserDefaultManager.savePunchInTime(punchInTime!)
      } else if !isPunchIn {
        punchInTime = nil
      }

      shouldUIHidden(isPunchIn)
      checkInBtnState(isSelected: punchInTime != nil)
    }
  }
  lazy var punchInTime: Date? = nil
  var punchInTimeStr: String? { punchInTime?.toString(dateFormat: .hourMinute) }

  @Published var isPunchOut: Bool = false {
    didSet {
      switch isPunchOut {
      case true:
        if isAutoPunchOut(), let savedOutTime = UserDefaultManager.getPunchOutTime() {
          punchOutTime = savedOutTime
        } else {
          punchOutTime = Date()
        }

        UserDefaultManager.removePunchInTime()

        guard let month = punchInTime?.toString(dateFormat: .month) else { return }

        dataManager.writeData(month: month, in: punchInTime, out: punchOutTime)

        resetData()
      case false:
        punchOutTime = nil
      }
      checkOutBtnState(isSelected: isPunchOut)
    }
  }
  lazy var punchOutTime: Date? = nil
  var punchOutTimeStr: String? { punchOutTime?.toString(dateFormat: .hourMinute) }

  private var workingHour: Double {
    UserDefaultManager.getWorkingHours() > 0 ? UserDefaultManager.getWorkingHours() : 9.0
  }

  var workingHourStr: String {
    isHoursInt ? "Work hard \(Int(workingHour)) hours" : "Work hard \(workingHour) hours"
  }

  @Published var dateStr: String = { Date().toString(dateFormat: .yearMonthDate) }()
  @Published var weekDayStr: String = { Date().toString(dateFormat: .weekday) }()
  @Published var currentTimeStr: String = { Date().toString(dateFormat: .hourMinute) }()

  @Published var quoteSubject: String = "Life has no limitations, except the ones you make."

  lazy var captionLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 240, height: 30))
    label.text = "Double-click to punch in"
    label.textColor = .white
    return label
  }()

  var weatherIcon: UIImage = {
    return UIImage(named: "weather04")!
  }()

  var checkInButton: TimeButton = {
    let btn = TimeButton(frame: CGRect(x: 30, y: 0, width: 300, height: 100))
    btn.setImage(button: .work(state: .notPunchIn))
    return btn
  }()
  lazy var checkOutButton: TimeButton = {
    let btn = TimeButton(frame: CGRect(x: 30, y: 200, width: 300, height: 100))
    btn.setImage(button: .offWork(state: .notPunchOut))
    return btn
  }()

  var isHoursInt: Bool { Int(workingHour * 10) % 10 == 0 }

  init() {
    getCurrentTime()
    getPunchInStateAndTime()
    loadQuote()

    pushManager?.delegate = self
  }

  deinit {
    timerSubscriber?.cancel()
  }
}

extension PunchClockViewModel {

  private func getPunchInStateAndTime() {
    if let savedTime = UserDefaultManager.getPunchInTime() {
      self.punchInTime = savedTime
    }
    self.isPunchIn = self.punchInTime != nil
  }

  func getCurrentTime() {
    timerSubscriber = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
      .sink(receiveValue: { [weak self] currentTime in
        self?.currentTimeStr = currentTime.toString(dateFormat: .hourMinute)
      })
  }

  private func cancelTimer() {
    self.timerSubscriber?.cancel()
  }

  func loadQuote() {
    let jsonData = readLocalJSONFile(forName: "Quotes")

    if let data = jsonData {
      if let quoteSrting = getQuote(jsonData: data) {
        self.quoteSubject = quoteSrting
      }
    }
  }

  private func isAutoPunchOut() -> Bool {
    if let outTime = UserDefaultManager.getPunchOutTime() {
      return UserDefaultManager.getAutoPunchOutState() && outTime <= Date()
    }
    return false
  }

  private func shouldUIHidden(_ isHidden: Bool) {
    captionLabel.isHidden = isHidden
    checkOutButton.isHidden = !isHidden
  }
}

extension PunchClockViewModel {

  func createCheckInButton(controller: PunchClockViewController, action: Selector) {
    $currentTimeStr
      .sink(receiveValue: { [weak self] title in
        self?.checkInButton.setTitle(string: title, button: .work(state: .notPunchIn))
      })
      .store(in: &cancellable)

    checkInButton.addTarget(controller, action: action, for: .touchDownRepeat)

    checkInButton.setImagePosition(type: .imageLeft, Space: 10)

    checkInButton.commonLayout(on: controller.view)
    checkInButton.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
  }

  func createCheckOutButton(controller: PunchClockViewController, action: Selector) {
    $currentTimeStr
      .sink(receiveValue: { [weak self] title in
        self?.checkOutButton.setTitle(string: title, button: .offWork(state: .notPunchOut))
      })
      .store(in: &cancellable)

    checkOutButton.addTarget(controller, action: action, for: .touchDownRepeat)

    checkOutButton.setImagePosition(type: .imageLeft, Space: 10)

    checkOutButton.commonLayout(on: controller.view)
    checkOutButton.topAnchor.constraint(equalTo: checkInButton.bottomAnchor, constant: 158)
      .isActive = true
  }

  private func checkInBtnState(isSelected: Bool) {
    checkInButton.isSelected = isSelected
    checkInButton.isUserInteractionEnabled = !isSelected

    if isSelected {
      checkInButton.setTitle(string: punchInTimeStr!, button: .work(state: .punchIn))
    }
  }

  func checkOutBtnState(isSelected: Bool) {
    checkOutButton.isSelected = isSelected
    checkOutButton.isUserInteractionEnabled = !isSelected

    if isSelected {
      checkOutButton.setTitle(string: punchOutTimeStr!, button: .offWork(state: .punchOut))
    }
  }

  func checkAutoPunchOut() {
    if isAutoPunchOut() {
      self.isPunchOut = true
    }
  }

  func resetData() {
    isPunchIn = false
    isPunchOut = false
  }

  func vibrate(intensity: Int = 3) {
    let vibrateFeedback = UIImpactFeedbackGenerator(style: .medium)
    vibrateFeedback.prepare()
    vibrateFeedback.impactOccurred(intensity: 3)
  }

  func displayAlert(
    _ viewController: UIViewController, title: String? = nil, message: String? = nil,
    actionTitle: String = "YAY"
  ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: actionTitle, style: .default)
    alertController.addAction(okAction)

    viewController.present(alertController, animated: true)
  }
}

extension PunchClockViewModel: PushManagerDelegate {
  func pushManagerDelegate(_ manager: PushManager, isOffWorkPushOn: Bool) {
    self.isOffWorkPushOn = isOffWorkPushOn
  }
}
