//
//  UIButton+Extension.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/6/14.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import UIKit

enum ButtonImagePosition: Int {
  case imageTop = 0
  case imageLeft
  case imageBottom
  case imageRight
}

extension UIButton {
  func setTitle(_ title: String?, for states: UIControl.State..., isUpperCased: Bool = false) {
    states.forEach {
      switch isUpperCased {
      case true:
        setTitle(title?.uppercased(), for: $0)
      case false:
        setTitle(title, for: $0)
      }
    }
  }

  func setImagePosition(type: ButtonImagePosition, Space space: CGFloat) {

    let imageWith: CGFloat = (imageView?.frame.size.width)!
    let imageHeight: CGFloat = (imageView?.frame.size.height)!

    var labelWidth: CGFloat = 0.0
    var labelHeight: CGFloat = 0.0

    labelWidth = CGFloat(titleLabel!.intrinsicContentSize.width)
    labelHeight = CGFloat(titleLabel!.intrinsicContentSize.height)

    var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets()
    var labelEdgeInsets: UIEdgeInsets = UIEdgeInsets()

    switch type {
    case .imageTop:
      imageEdgeInsets = UIEdgeInsets.init(
        top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
      labelEdgeInsets = UIEdgeInsets.init(
        top: 0, left: -imageWith, bottom: -imageHeight - space / 2.0, right: 0)
      break
    case .imageLeft:
      imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
      labelEdgeInsets = UIEdgeInsets.init(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
      break
    case .imageBottom:
      imageEdgeInsets = UIEdgeInsets.init(
        top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
      labelEdgeInsets = UIEdgeInsets.init(
        top: -imageHeight - space / 2.0, left: -imageWith, bottom: 0, right: 0)
      break
    case .imageRight:
      imageEdgeInsets = UIEdgeInsets.init(
        top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
      labelEdgeInsets = UIEdgeInsets.init(
        top: 0, left: -imageWith - space / 2.0, bottom: 0, right: imageWith + space / 2.0)
      break
    }
    self.titleEdgeInsets = labelEdgeInsets
    self.imageEdgeInsets = imageEdgeInsets
  }

  func setBackgroundColor(color: UIColor, forState: UIControl.State) {
    self.clipsToBounds = true  // add this to maintain corner radius
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
      let colorImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.setBackgroundImage(colorImage, for: forState)
    }
  }

  // 統一按鈕樣式
  enum ButtonStyle {
    case primary  // 主要按鈕 (藍色)
    case secondary  // 次要按鈕 (淺灰色)
    case danger  // 危險按鈕 (紅色)
    case success  // 成功按鈕 (綠色)
  }

  // 套用統一的按鈕樣式
  func applyStyle(_ style: ButtonStyle) {
    self.layer.cornerRadius = 10  // 統一更大的圓角
    self.clipsToBounds = false  // 設置為 false 才能顯示陰影
    self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    self.setTitleColor(.white, for: .normal)

    // 添加輕微陰影效果使按鈕更突出
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.shadowOpacity = 0.2
    self.layer.shadowRadius = 3
    self.layer.masksToBounds = false  // 允許陰影顯示

    switch style {
    case .primary:
      self.backgroundColor = UIColor.init(netHex: 0x5976BB)  // 藍色
    case .secondary:
      self.backgroundColor = UIColor.veryLightGray  // 淺灰色
    case .danger:
      self.backgroundColor = UIColor.systemRed  // 紅色
    case .success:
      self.backgroundColor = UIColor.systemGreen  // 綠色
    }
  }

  // 設置常用按鈕尺寸
  func setStandardSize() {
    self.heightAnchor.constraint(equalToConstant: 44).isActive = true
    self.layer.cornerRadius = 10  // 統一為 10 的圓角
    self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
  }
}
