// LoginViewModel.swift
// WorkPal — Features/Login/ViewModels
//
// 原始：CompanyAppLoginVC 的驗證邏輯
// ✅ IBOutlet text → @Published
// ✅ IBAction → Intent 方法
// ✅ UITextFieldDelegate 邏輯 → computed property

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Published State（原 @IBOutlet）
    @Published var username: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoggedIn = false
    @Published var showLoginError = false

    // MARK: - Computed（原 setupLoginButtonStatus）
    var isLoginButtonEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }

    var appTitle: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "WorkPal"
    }

    // MARK: - Dependencies
    private let validCredentials: (username: String, password: String)

    init(validUsername: String = "user", validPassword: String = "pass.123") {
        self.validCredentials = (validUsername, validPassword)
    }

    // MARK: - Intents（原 IBAction loginButtonClicked）
    func login() {
        if checkCredentials() {
            isLoggedIn = true
        } else {
            showLoginError = true
        }
    }

    func logout() {
        isLoggedIn = false
        username = ""
        password = ""
    }

    // MARK: - Private（原 checkUserInfoIsValid）
    private func checkCredentials() -> Bool {
        username == validCredentials.username && password == validCredentials.password
    }
}
