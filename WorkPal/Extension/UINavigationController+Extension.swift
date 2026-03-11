//
//  UINavigationController+Extension.swift
//  bet188asia
//
//  Created by Pat Chang on 4/21/21.
//  Copyright © 2021 Xuenn. All rights reserved.
//

import UIKit

extension UINavigationController {
    open func hasViewController(ofKind kind: AnyClass) -> Bool { (self.viewControllers.first(where: {$0.isKind(of: kind)}) != nil) }
}
