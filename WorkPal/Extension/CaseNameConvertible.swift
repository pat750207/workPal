//
//  CaseIterable+CaseNameConvertible.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 05/03/2018.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//



public protocol CaseNameConvertible {
    var caseName: String { get }
}

extension CaseNameConvertible {
    public var caseName: String { return String(describing: self) }
}

/// CaseTransparenable is provided for transform between enum types with same case name
protocol CaseTransparenable: CaseNameConvertible, CaseIterable {
    init?<T: CaseNameConvertible>(enumCase: T)
}


extension CaseTransparenable {
    init?<T: CaseNameConvertible>(enumCase: T) {
        guard let instanceCase = Self.allCases.first(where: { $0.caseName.lowercased() == enumCase.caseName.lowercased() }) else { return nil }
        self = instanceCase
    }
}
