//
//  UILabelPadding.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2020/2/12.
//  Copyright © 2020 Xuenn Pte Ltd. All rights reserved.
//

import UIKit

class UILabelPadding : UILabel {
    
    private var padding = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: padding)
        let rect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -padding.top,
                                          left: -padding.left,
                                          bottom: -padding.bottom,
                                          right: -padding.right)
        return rect.inset(by: invertedInsets)
    }
}

extension UILabel {

    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
         
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelTextSize = (labelText as NSString)
            .boundingRect(with: rect, options: .usesLineFragmentOrigin,
                          attributes: [NSAttributedString.Key.font: self.font!], context: nil)
         
        let labelTextLines = Int(ceil(CGFloat(labelTextSize.height) / self.font.lineHeight))
         
        return labelTextLines > self.numberOfLines
    }
}

@IBDesignable
extension UILabelPadding {
    
    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
}
