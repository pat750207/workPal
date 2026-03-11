//
//  BundleIDManager.swift
//  eInfoSys
//
//  Created by Pat Chang  (XN-188Asia) on 2025/3/12.
//

import Foundation

enum CompanyApp: String {
    case eInfoSys
    case Orange
    case Papaya
    case Younify
    case Gentalk
    
    var bundleID: String {
        switch self {
        case .eInfoSys:
            return "com.eInfo.sys"
        case .Orange:
            return "com.opg.sys"
        case .Papaya:
            return "com.gtv.sys"
        case .Younify:
            return "com.lipn.sys"
        case .Gentalk:
            return "com.genkok.sys"
        }
    }
}

class BundleIDManager {
    
    var companyApp: CompanyApp?
    
    static let shared = BundleIDManager()
    
    init() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        switch bundleIdentifier {
        case CompanyApp.eInfoSys.bundleID:
            companyApp = .eInfoSys
        case CompanyApp.Orange.bundleID:
            companyApp = .Orange
        case CompanyApp.Papaya.bundleID:
            companyApp = .Papaya
        case CompanyApp.Younify.bundleID:
            companyApp = .Younify
        case CompanyApp.Gentalk.bundleID:
            companyApp = .Gentalk
        default: break
        }
    }
}

