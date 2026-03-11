//
//  NSTextAttachment+Image.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/6/15.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

extension NSTextAttachment {
    func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }
}
