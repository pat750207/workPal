//
//  ProjectConfig.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 22/09/2017.
//  Copyright © 2017 Xuenn Pte Ltd. All rights reserved.
//

import Foundation

struct ProjectConfig {
    
    @Plist(key: "JPush_AppKey")
    static var jPushAppKey : String?
    
    @Plist(key: "RTMS_Domains")
    static var rtmsDomains: String?

    @Plist(key: "AdaChatLaunchKey")
    static var adaChatLaunchKey: String?
    
    @Plist(key: "188_Payment_SubDomain")
    static var paymentSubDomain : String?
    
    @Plist(key: "CFBundleShortVersionString")
    static var version : String?
    
//    @PlistTrans(key: "188_VersionCheckURL", handler: MultiValuedString.parse)
//    static var versionCheckURL : [String]?
//    
    @Plist(key: kCFBundleNameKey as String)
    static var bundleName : String?
    

//    @PlistTrans(key: "188_Build_Environment", handler: { BuildEnv(rawValue: $0 ?? "") ?? .QAT })
//    static var buildEnv : BuildEnv
    
    @Plist(key: "JumioCallBackURL")
    static var jumioCallBackURL: String? 

//    @PlistTrans(key: "Domain_SBKStatement", handler: MultiValuedString.parse)
//    static var SBKStatementDomains : [String]?
//    
//    @PlistTrans(key: "Lotto_Domains", handler: MultiValuedString.parse)
//    static var lottoDomains : [String]?

    @Plist(key: "BrandCode_SBK")
    static var brandCode_SBK: String?
    
    static var nameSpace : String {  String(reflecting: self).components(separatedBy: ".").first! }
}

@propertyWrapper
struct Plist {
    let key: String
    var wrappedValue: String? { Bundle.main.object(forInfoDictionaryKey: key) as? String }
}

@propertyWrapper
struct PlistTrans<Value> {
    let key: String
    let handler: ((String?) -> Value)
    var wrappedValue: Value {
        handler(Bundle.main.object(forInfoDictionaryKey: key) as? String)
    }
}
