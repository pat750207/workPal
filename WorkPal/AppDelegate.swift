//
//  AppDelegate.swift
//  WorkPal
//
//  Created by Pat Chang  (XN-188Asia) on 2025/4/24.
//

import UIKit

// @main  // ⚠️ 已移除：改用 WorkPalApp.swift 作為 SwiftUI 入口
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Force app to always use dark mode
    if #available(iOS 13.0, *) {
      // Scene-based app 在 SceneDelegate 中設置 UI style
      UIApplication.shared.windows.forEach { window in
        window.overrideUserInterfaceStyle = .dark
      }
    }
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(
    _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(
      name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }

}
