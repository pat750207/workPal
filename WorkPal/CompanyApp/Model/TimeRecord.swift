//
//  TimeRecord.swift
//  PunchClock

import Foundation

struct TimeRecord: Codable {
    
    var inTime: Date?
    var outTime: Date?
    
}

extension TimeRecord {
    
    // save in and out
    init(in: Date? = nil, out: Date? = nil) {
        self.inTime = `in`
        self.outTime = out
    }
    
    var inTimeString: String {
        self.inTime?.toString(dateFormat: .all) ?? "Not Punch in yet"
    }
    
    var outTimeString: String {
        self.outTime?.toString(dateFormat: .all) ?? "Not Punch out yet"
    }
}
