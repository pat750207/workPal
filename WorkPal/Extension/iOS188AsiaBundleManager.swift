//
//  ProjectBundleManager.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2017/12/13.
//  Copyright © 2017年 Xuenn Pte Ltd. All rights reserved.
//

import Foundation


final class MainBundle188Asia {}

extension Bundle {
    static var mainBundle188Asia : Bundle { return Bundle(for: MainBundle188Asia.self) }
}
