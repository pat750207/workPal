//
//  DashboardViewController.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2022/11/09.
//

var MASK_BALANCE = "MASK_BALANCE"

import Foundation

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
    
    
    @objc dynamic var maskBalance: Bool {
            get {
                self.bool(forKey: MASK_BALANCE)
            }
            set {
                self.setValue(newValue, forKey: MASK_BALANCE)
            }
        }
}
