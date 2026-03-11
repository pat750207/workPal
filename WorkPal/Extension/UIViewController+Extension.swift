//
//  UIViewController+Extension.swift
//  WorkPal
//
//  Created by Pat Chang  (XN-188Asia) on 2025/4/24.
//

import Foundation
import UIKit

extension UIViewController {
  func topMostViewController() -> UIViewController {
    if let presented = self.presentedViewController {
      return presented.topMostViewController()
    }

    if let nav = self as? UINavigationController {
      return nav.visibleViewController?.topMostViewController() ?? nav
    }

    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController() ?? tab
    }

    return self
  }
}
