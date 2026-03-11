//
//  CompanyAppLoginVC.swift
//  iOS-188Asia
//
//  Created by Pat Chang  (XN-188Asia) on 2025/1/14.
//

import UIKit

struct CompanyUser {
  var username: String
  var password: String
}

class CompanyAppLoginVC: UIViewController {

  @IBOutlet weak var usernameTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!

  let user = CompanyUser(username: "user", password: "pass.123")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextfield.delegate = self
    self.passwordTextfield.delegate = self
    self.passwordTextfield.isSecureTextEntry = true
    self.setupLoginButtonStatus(enable: false)
    self.titleLabel.text = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""  //BundleIDManager.shared.companyApp?.rawValue

    let lightGrayPlaceholderAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.veryLightGray
    ]
    usernameTextfield.attributedPlaceholder = NSAttributedString(
      string: "Username", attributes: lightGrayPlaceholderAttributes)
    passwordTextfield.attributedPlaceholder = NSAttributedString(
      string: "Password", attributes: lightGrayPlaceholderAttributes)
  }

  @IBAction func loginButtonClicked(_ sender: UIButton) {

    if self.checkUserInfoIsValid() {
      self.goToMainTabBar()
    } else {
      UIHelper.showDialog(
        title: "Login failed",
        message: "Invalid Username and Password.\nPlease try again!",
        okTitle: "OK",
        onOK: {

        }
      )
    }

  }

  func goToMainTabBar() {
    let mainTabBarVC = MainTabBarViewController()

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first
    {
      window.rootViewController = mainTabBarVC
      UIView.transition(
        with: window, duration: 0.3, options: [.transitionFlipFromRight], animations: nil)
    }
  }

  private func checkUserInfoIsValid() -> Bool {
    return self.usernameTextfield.text == self.user.username
      && self.passwordTextfield.text == self.user.password
  }

  private func setupLoginButtonStatus(enable: Bool) {
    self.loginButton.isEnabled = enable

    // 使用統一按鈕樣式
    if enable {
      self.loginButton.applyStyle(.primary)
    } else {
      self.loginButton.applyStyle(.secondary)
    }

    // 確保禁用狀態的顏色也是白色
    self.loginButton.setTitleColor(.white, for: .disabled)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(false)
  }

}

extension CompanyAppLoginVC: UITextFieldDelegate {

  func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    if let input = textField.text {
      let enable =
        !(input.count + string.count - range.length == 0)
        && [usernameTextfield, passwordTextfield]
          .filter { $0 != textField }
          .reduce(true) { $0 && !($1.text?.isEmpty ?? true) }
      self.setupLoginButtonStatus(enable: enable)
    }

    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == passwordTextfield {
      textField.text = nil
      self.setupLoginButtonStatus(enable: false)
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
