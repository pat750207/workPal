//
//  UIColor+Extension.swift
//  bet188asia
//
//  Created by Pat Chang on 2016/8/4.
//  Copyright © 2016年 Xuenn. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert((0...255).contains(red), "Invalid red component")
    assert((0...255).contains(green), "Invalid green component")
    assert((0...255).contains(blue), "Invalid blue component")

    self.init(
      red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0,
      alpha: 1.0)
  }
  convenience init(netHex: Int) {
    self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
  }

  static let shadowColor = UIColor(red: 0.631, green: 0.678, blue: 0.722, alpha: 0.3)

  // 深色模式下的顏色
  static let white70 = UIColor.init(red: 45, green: 45, blue: 50)
  static let white80 = UIColor.init(red: 35, green: 35, blue: 40)
  static let white90 = UIColor.init(red: 30, green: 30, blue: 35)

  static let black70 = UIColor.init(red: 161, green: 173, blue: 184)
  static let black80 = UIColor.init(red: 115, green: 122, blue: 128)
  static let black90 = UIColor.init(red: 51, green: 51, blue: 51)

  static let primaryBlue = UIColor.init(red: 96, green: 191, blue: 245)
  static let darkBlue = UIColor.init(red: 0, green: 38, blue: 59)

  // 非常淺的灰色，接近白色
  static let veryLightGray = UIColor(white: 0.6, alpha: 0.6)
}
