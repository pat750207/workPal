// LoginView.swift
// WorkPal — Features/Login/Views
//
// 原始：CompanyAppLoginVC.swift + CompanyAppLoginVC.xib
// ✅ @IBOutlet → @Published state
// ✅ UITextFieldDelegate → onChange / computed
// ✅ UIView.transition → withAnimation
// ✅ touchesEnded → .onTapGesture + FocusState

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?

    private enum Field { case username, password }

    var body: some View {
        ZStack {
            // 深色背景
            Color(red: 0.08, green: 0.08, blue: 0.08)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // App 標題（原 titleLabel）
                Text(viewModel.appTitle)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)

                VStack(spacing: 16) {
                    // Username（原 usernameTextfield + placeholder）
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }

                    // Password（原 passwordTextfield + isSecureTextEntry）
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit { if viewModel.isLoginButtonEnabled { viewModel.login() } }

                    // Login 按鈕（原 loginButton + applyStyle）
                    Button {
                        focusedField = nil
                        viewModel.login()
                    } label: {
                        Text("Login")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                viewModel.isLoginButtonEnabled
                                    ? Color.blue
                                    : Color.gray.opacity(0.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!viewModel.isLoginButtonEnabled)
                }
                .padding(.horizontal, 32)

                Spacer()
                Spacer()
            }
        }
        // 原 touchesEnded → 點擊空白處收起鍵盤
        .onTapGesture { focusedField = nil }
        // 原 UIHelper.showDialog → alert
        .alert("Login failed", isPresented: $viewModel.showLoginError) {
            Button("OK") {}
        } message: {
            Text("Invalid Username and Password.\nPlease try again!")
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
