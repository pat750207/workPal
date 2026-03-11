//
//  UIAlertController+Actions.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/6/5.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func with(actions: [UIAlertAction]) -> Self {
        actions.forEach { addAction($0) }
        return self
    }
}
