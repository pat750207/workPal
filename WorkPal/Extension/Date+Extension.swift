//
//  Date+Extension.swift
//  PunchClock
//
//  Created by Pat Chang on 2023/7/12.
//

import Foundation.NSData

extension Date {
    
    func toString(dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
}

enum DateFormat: String {
    
    case all = "yyyy/MM/dd HH:mm"
    case hourMinute = "HH:mm"
    case yearMonthDate = "MMM / dd / yyyy"
    case weekday = "EEEE"
    case month = "MMM"
}
