// WorkPalApp.swift
// WorkPal
//
// 原始：AppDelegate.swift + SceneDelegate.swift
// ✅ @main UIApplicationDelegate → @main App
// ✅ UIWindow + rootViewController → WindowGroup
// ✅ overrideUserInterfaceStyle = .dark → .preferredColorScheme(.dark)

import SwiftUI

// 注意：已移除原本 AppDelegate.swift 的 @main，避免衝突
@main
struct WorkPalApp: App {

    @StateObject private var loginViewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(loginViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
