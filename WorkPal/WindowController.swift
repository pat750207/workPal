//
//  WindowController.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2019/1/9.
//  Copyright © 2019 Xuenn Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

public let UIWindowLevelGestureLock: UIWindow.Level = UIWindow.Level.alert - 1
public let UIWindowLevelAlertDialog: UIWindow.Level = UIWindow.Level.alert - 2
public let UIWindowLevelBetSlip    : UIWindow.Level = UIWindow.Level.alert - 3
public let UIWindowLevelFeature    : UIWindow.Level = UIWindow.Level.alert - 4

protocol WindowController {
    var window: UIWindow { get }
    static var uniqueWindow: UIWindow? { get set }
    func show(onCompletion: (() -> Void)?)
    static func dismiss(onCompletion: (() -> Void)?)
}

extension WindowController {
    
    func show(onCompletion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if type(of: self).uniqueWindow?.isKeyWindow == .some(true) { return }
            type(of: self).uniqueWindow = self.window
            type(of: self).uniqueWindow?.makeKeyAndVisible()
            onCompletion?()
        }
    }
    
    static func dismiss(onCompletion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard uniqueWindow?.isKeyWindow == .some(true) else { return }
            onCompletion?()
            uniqueWindow = nil
        }
    }
}


