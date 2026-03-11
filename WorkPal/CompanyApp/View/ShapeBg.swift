//
//  shape.swift
//  RainbowDemo
//

import UIKit

class ShapeBg: UIView {

  var topLeftY: CGFloat = 0
  var topRightY: CGFloat = 0

  let endY: Int = Int(UIScreen.main.bounds.size.height)
  let endX: Int = Int(UIScreen.main.bounds.size.width)

  @IBInspectable var topLeftYValue: CGFloat = 0 {
    didSet {
      self.topLeftY = topLeftYValue
      setNeedsDisplay()
    }
  }

  @IBInspectable var topRightYValue: CGFloat = 0 {
    didSet {
      self.topRightY = topRightYValue
      setNeedsDisplay()
    }
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    // 使用固定起點和控制點，確保圓弧形狀穩定
    let startY: CGFloat = 30.0

    // 控制點比起點低很多，形成明顯但不過度的圓弧
    let controlY: CGFloat = -10.0

    // 根據視圖實際大小計算點位置
    let shapePath = UIBezierPath()

    // 從左下角開始繪製
    shapePath.move(to: CGPoint(x: 0, y: rect.height))

    // 連線到左側頂部點
    shapePath.addLine(to: CGPoint(x: 0, y: startY))

    // 添加頂部曲線 - 從左側到右側，向上彎曲
    shapePath.addQuadCurve(
      to: CGPoint(x: rect.width, y: startY),
      controlPoint: CGPoint(x: rect.width / 2, y: controlY))

    // 連線到右下角
    shapePath.addLine(to: CGPoint(x: rect.width, y: rect.height))

    // 閉合路徑回到起點
    shapePath.close()

    // 創建圖形層並直接設置顏色
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = shapePath.cgPath

    // 使用更明顯的漸變填充
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [
      UIColor(white: 0.2, alpha: 0.8).cgColor,  // 頂部顏色
      UIColor(white: 0.1, alpha: 0.95).cgColor,  // 底部顏色
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.mask = shapeLayer

    // 清除所有舊的子圖層
    layer.sublayers?.removeAll()
    layer.addSublayer(gradientLayer)
  }
}
