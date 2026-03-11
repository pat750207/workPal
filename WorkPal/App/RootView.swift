// RootView.swift
// WorkPal
//
// 原始：SceneDelegate 的 window.rootViewController 切換邏輯
// ✅ UIWindow rootViewController 切換 → @Published isLoggedIn 驅動
// ✅ UIView.transition（flip）→ withAnimation transition

import SwiftUI

struct RootView: View {

    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        Group {
            if loginViewModel.isLoggedIn {
                MainTabView()
                    .transition(.move(edge: .trailing))
            } else {
                LoginView(viewModel: loginViewModel)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: loginViewModel.isLoggedIn)
    }
}

#Preview {
    RootView()
        .environmentObject(LoginViewModel())
}
