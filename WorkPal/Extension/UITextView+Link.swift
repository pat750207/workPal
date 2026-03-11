//
//  UITextView+Link.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2022/4/12.
//  Copyright © 2022 Xuenn Pte Ltd. All rights reserved.
//

import UIKit

extension UITextView {

    func appendLinkString(string: String , withURLString: String = "") {
        
        let attrString: NSMutableAttributedString = NSMutableAttributedString ()
        attrString.append(self.attributedText)
        
        let attrs = [NSAttributedString.Key.font : self.font!]
        let appendString = NSMutableAttributedString (string: string, attributes:attrs)
        
        if withURLString != "" {
            let range: NSRange  =  NSMakeRange (0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        
        attrString.append(appendString)
        self.attributedText = attrString
        self.linkTextAttributes = [.foregroundColor: #colorLiteral(red: 0, green: 0.6235294118, blue: 0.8509803922, alpha: 1)]
    }
}
