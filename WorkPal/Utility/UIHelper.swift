//
//  UIHelper.swift
//  WorkPal
//
//  Created by Pat Chang  (XN-188Asia) on 2025/4/24.
//

import Foundation
import UIKit

class UIHelper {
  static func showDialog(
    title: String,
    message: String,
    okTitle: String = "OK",
    cancelTitle: String = "Cancel",
    onOK: (() -> Void)? = nil,
    onCancel: (() -> Void)? = nil
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
      onOK?()
    }

    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
      onCancel?()
    }

    alert.addAction(cancelAction)
    alert.addAction(okAction)

    DispatchQueue.main.async {
      if let topVC = UIApplication.shared.windows.first?.rootViewController?.topMostViewController()
      {
        topVC.present(alert, animated: true, completion: nil)
      }
    }
  }
}
