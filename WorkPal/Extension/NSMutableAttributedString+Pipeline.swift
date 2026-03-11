//
//  NSMutableAttributedString+Pipeline.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/4/16.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import Foundation

public extension NSMutableAttributedString {
    
    func with(attrs: [NSAttributedString.Key : Any], for subString: String?) -> Self {
        guard let subString = subString else { return self }
        return with(attrs: attrs, range: (string as NSString).range(of: subString))
    }
    
    func with(attrs: [NSAttributedString.Key : Any], range: NSRange) -> Self {
        addAttributes(attrs, range: range)
        return self
    }
    
    func appending(_ attributedString: NSAttributedString) -> Self {
        append(attributedString)
        return self
    }
}
