//
//  timeButton.swift
//  PunchClock

import UIKit

class TimeButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.titleLabel?.textAlignment = .left
    self.contentHorizontalAlignment = .left

    self.setTitleColor(.white, for: .highlighted)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setImage(button style: ButtonStyle) {
    switch style {

    case .work(_):
      self.setImage(WorkState.notPunchIn.image, for: .normal)
      self.setImage(WorkState.punchIn.image, for: .selected)

    case .offWork(_):
      self.setImage(OffWorkState.notPunchOut.image, for: .normal)
      self.setImage(OffWorkState.punchOut.image, for: .selected)
    }
  }

  func setTitle(string: String, button style: ButtonStyle) {
    switch style {
    case .work(let state):
      let attributedText = NSMutableAttributedString(
        string: string,
        attributes: [
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .medium),
          NSAttributedString.Key.foregroundColor: state.color,
        ])
      let controlState: UIControl.State = state == .notPunchIn ? .normal : .selected
      self.setAttributedTitle(attributedText, for: controlState)

    case .offWork(let state):
      let attributedText = NSMutableAttributedString(
        string: string,
        attributes: [
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .medium),
          NSAttributedString.Key.foregroundColor: state.color,
        ])
      let controlState: UIControl.State = state == .notPunchOut ? .normal : .selected
      self.setAttributedTitle(attributedText, for: controlState)
    }
  }

  func commonLayout(on view: UIView) {
    view.addSubview(self)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
      self.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
    ])
  }
}

extension TimeButton {

  enum ButtonStyle {
    case work(state: WorkState)
    case offWork(state: OffWorkState)
  }

  enum WorkState {
    case notPunchIn
    case punchIn

    var color: UIColor {
      switch self {
      case .notPunchIn:
        return .white
      case .punchIn:
        return .white
      }
    }

    var image: UIImage {
      switch self {
      case .notPunchIn:
        return UIImage(named: "msgUnchecked")!
      case .punchIn:
        return UIImage(named: "checkbox-marked-rounded")!
      }
    }
  }

  enum OffWorkState {
    case notPunchOut
    case punchOut

    var color: UIColor {
      switch self {
      case .notPunchOut:
        return .white
      case .punchOut:
        return .white
      }
    }

    var image: UIImage {
      switch self {
      case .notPunchOut:
        return UIImage(named: "checkbox-minus-rounded")!
      case .punchOut:
        return UIImage(named: "checkbox-marked-rounded")!
      }
    }
  }
}
