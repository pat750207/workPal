//
//  UIView+Extension.swift
//  bet188asia
//
//  Created by Pat Chang on 2017/2/18.
//  Copyright © 2017年 Xuenn. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    
    @objc func rotate(_ shouldRotate: Bool = true, duration: CFTimeInterval = 1.0) {
        if shouldRotate {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat.pi * 2
            rotateAnimation.duration = duration
            rotateAnimation.repeatCount = Float.infinity
            layer.add(rotateAnimation, forKey: nil)
        } else {
            layer.removeAllAnimations()
            layer.sublayers?.removeAll()
        }
    }
    
    
    func progress(percentage: CGFloat = CGFloat.random(in: (0.3...0.8)), animated: Bool = false, completionHandler: (() -> Void)? = nil) {
        layer.sublayers?.first { $0 is CAShapeLayer }?.removeFromSuperlayer()
        
        CATransaction.begin()
        let levelLayer = CAShapeLayer()
        levelLayer.fillColor = UIColor(red: 221, green: 221, blue: 221).cgColor
        levelLayer.lineWidth = 3.0
        levelLayer.path = UIBezierPath(roundedRect: CGRect(x: frame.origin.x,
                                                           y: frame.origin.y,
                                                           width: frame.width * percentage,
                                                           height: frame.height),
                                       cornerRadius: 0).cgPath
        if animated {
            let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale.x")
            animation.fromValue = 0.0
            animation.toValue = 1
            animation.duration = 0.35
            CATransaction.setCompletionBlock(completionHandler)
            levelLayer.add(animation, forKey: "transform.scale.x")
            CATransaction.commit()
        }
        
        layer.insertSublayer(levelLayer, at: 0)
    }
}

class CircularProgressBar: UIView, CAAnimationDelegate {
    
    let shapeLayer = CAShapeLayer()
    let backgroundShapeLayer = CAShapeLayer()
    //    var circularPath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Frame: \(self.frame)")
        makeCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircle()
    }
    
    func makeCircle() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.bounds.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        backgroundShapeLayer.path = circularPath.cgPath
        backgroundShapeLayer.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32).cgColor
        backgroundShapeLayer.lineWidth = 2.0
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.lineCap = CAShapeLayerLineCap.square
        backgroundShapeLayer.strokeEnd = 1
        backgroundShapeLayer.position = self.center
        backgroundShapeLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi / 2, 0, 0, 1)
        self.layer.addSublayer(backgroundShapeLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.square
        shapeLayer.strokeEnd = 1
        shapeLayer.position = self.center
        shapeLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi / 2, 0, 0, 1)
        self.layer.addSublayer(shapeLayer)
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.delegate = self
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 1
        animation.toValue = 0
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Set the circleLayer's strokeEnd property to 0.0 now so that it's the
        // right value when the animation ends.
        shapeLayer.strokeEnd = 0
        
        // Do the actual animation
        shapeLayer.add(animation, forKey: "animateCircle")
    }
    
    func showProgress(percent: Float){
        shapeLayer.strokeEnd = CGFloat(percent/100)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        backgroundShapeLayer.strokeColor = UIColor.clear.cgColor
    }
}
