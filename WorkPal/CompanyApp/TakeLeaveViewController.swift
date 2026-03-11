//
//  TakeLeaveViewController.swift
//  eInfoSys
//
//  Created by Pat Chang  (XN-188Asia) on 2025/3/3.
//

import UIKit

public let fullScreenSize = UIScreen.main.bounds.size

class TakeLeaveViewController: UIViewController {

  @IBOutlet weak var leaveReasonTextView: UITextView!
  @IBOutlet weak var startTimeTextField: UITextField!
  @IBOutlet weak var endTimeTextField: UITextField!
  @IBOutlet weak var leaveTypeLabel: UILabel!
  var activeTextField: UITextField?
  let leaveReasonPlaceholder = "Leave reason"
  var leaveTypePickerView: MyPicker!
  var leaveType: LegacyLeaveType = .sickLeave
  let datePicker = UIDatePicker()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupView()
  }

  private func setupView() {
    self.leaveReasonTextView.delegate = self
    self.leaveReasonTextView.text = self.leaveReasonPlaceholder
    self.leaveReasonTextView.textColor = UIColor.veryLightGray

    self.leaveTypeLabel.text = LegacyLeaveType.allCases.first?.rawValue
    self.leaveTypePickerView = MyPicker.init(
      frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: fullScreenSize.height))
    self.leaveTypePickerView.delegate = self

    self.datePicker.datePickerMode = .dateAndTime
    self.datePicker.preferredDatePickerStyle = .wheels
    self.datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    self.datePicker.locale = Locale(identifier: "en_US")

    self.startTimeTextField.inputView = datePicker
    self.endTimeTextField.inputView = datePicker
    self.startTimeTextField.delegate = self
    self.endTimeTextField.delegate = self

    let toolbar = UIToolbar()
    toolbar.sizeToFit()

    let doneButton = UIBarButtonItem(
      title: "Done", style: .plain, target: self, action: #selector(dismissDatePicker))
    toolbar.setItems([doneButton], animated: true)

    startTimeTextField.inputAccessoryView = toolbar
    endTimeTextField.inputAccessoryView = toolbar
  }

  @objc func dismissDatePicker() {
    view.endEditing(true)
  }

  @objc func datePickerChanged(datePicker: UIDatePicker) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let time = formatter.string(from: datePicker.date)
    activeTextField?.text = time
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(false)
  }

  @IBAction func leaveTypeButtonClicked(_ sender: UIButton) {
    self.leaveReasonTextView.resignFirstResponder()
    self.startTimeTextField.resignFirstResponder()
    self.endTimeTextField.resignFirstResponder()
    self.leaveTypePickerView.show()
  }

  @IBAction func sendButtonClicked(_ sender: UIButton) {
    self.leaveReasonTextView.resignFirstResponder()
    self.startTimeTextField.resignFirstResponder()
    self.endTimeTextField.resignFirstResponder()

    guard let startTime = self.startTimeTextField.text, let endTime = self.endTimeTextField.text
    else { return }
    if startTime.isEmpty || endTime.isEmpty {

      UIHelper.showDialog(
        title: "Error",
        message: "Please fill in the start time and end time.",
        okTitle: "OK",
        onOK: {

        }
      )
    } else {
      self.takeLeaveSubmitted()
    }
  }

  private func takeLeaveSubmitted() {

    UIHelper.showDialog(
      title: "Sent successfully",
      message: "",
      okTitle: "OK",
      onOK: {
        self.startTimeTextField.text = ""
        self.endTimeTextField.text = ""
        self.leaveReasonTextView.text = ""
      }
    )

    //        let parameters: [String: Any] = ["leaveType": self.leaveType.rawValue, "startDate": self.startTimeTextField.text ?? "", "endDate": self.endTimeTextField.text ?? "", "reason": self.leaveReasonTextView.text ?? "", "token": CompanyAppManager.shared.token ?? ""]
    //        CompanyAppManager.shared.companyApiFire(apiKey: .takeLeave, body: parameters) { isSuccess, response in
    //            DispatchQueue.main.async {
    //                if isSuccess {
    //
    //                    UIHelper.showDialog(
    //                        title: "Sent successfully",
    //                        message: "",
    //                        okTitle: "OK",
    //                        onOK: {
    //                            self.startTimeTextField.text = ""
    //                            self.endTimeTextField.text = ""
    //                            self.leaveReasonTextView.text = ""
    //                        }
    //                    )
    //                } else {
    //                    UIHelper.showDialog(
    //                        title: "Fail",
    //                        message: "sent failed",
    //                        okTitle: "OK",
    //                        onOK: {
    //                        }
    //                    )
    //                }
    //            }
    //        }
  }
}

extension TakeLeaveViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let time = formatter.string(from: Date())
    activeTextField?.text = time
  }
}

extension TakeLeaveViewController: MyPickerDelegate {
  func updateText(_ text: String, leaveType: LegacyLeaveType) {
    self.leaveTypeLabel.text = text
    self.leaveType = leaveType
  }
}

extension TakeLeaveViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.veryLightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = self.leaveReasonPlaceholder
      textView.textColor = UIColor.veryLightGray
    }
  }
}
