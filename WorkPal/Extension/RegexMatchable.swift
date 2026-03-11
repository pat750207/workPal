//
//  RegexMatchable.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/7/19.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import Foundation

public struct Regex {
    public let pattern: String
}

public protocol RegexMatchable : StringProtocol {
    static func ~=(regex: Regex, input: Self) -> Bool
    func match(regex: Regex) -> Bool
    func matches(with regex: Regex, options: NSRegularExpression.Options) -> [String]
    func capturedGroups(with regex: Regex, options: NSRegularExpression.Options) -> [String]
}

public extension RegexMatchable {
    
    var regex: Regex { return Regex(pattern: String(self)) }
    
    func match(regex: Regex) -> Bool {
        return regex ~= self
    }
    
    static func ~=(regex: Regex, input: Self) -> Bool {
        return String(input).range(of: regex.pattern, options: .regularExpression) != nil
    }
}

public extension Optional where Wrapped: RegexMatchable {
    static func ~=(regex: Regex, input: Optional<Wrapped>) -> Bool {
        return input?.match(regex: regex) ?? false
    }
}
