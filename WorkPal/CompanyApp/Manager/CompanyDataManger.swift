//
//  CompanyDataManger.swift
//  eInfoSys
//
//  Created by Pat Chang (XN-188Asia) on 2025/2/21.
//

import Foundation

class CompanyDataManger {
    
    public static let shared = CompanyDataManger()
    private var fileManager: FileManager
    private var records: Array<TimeRecord> = []
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func writeData(month: String, in: Date? = nil, out: Date? = nil){
        do {
            let fileURL = try FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent(month).appendingPathExtension("json")
            
            let record = TimeRecord(in: `in`, out: out)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                fetch(month: month){
                    self.records = $0
                }
                self.records.append(record)
                
                try JSONEncoder().encode(self.records).write(to: fileURL)
                
            }else{
                try JSONEncoder().encode([record]).write(to: fileURL)
            }
            
            
        } catch {
            print("Error while writing the data")
        }
    }
    
    func fetch(month: String, completeHandler: @escaping([TimeRecord]) -> Void) {
        do {
            let fileURL = try FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent(month).appendingPathExtension("json")
                
            guard fileManager.fileExists(atPath: fileURL.path) else {
                return
            }
                
            let data = try Data(contentsOf: fileURL)
            let pastData = try JSONDecoder().decode([TimeRecord].self, from: data)
            
            completeHandler(pastData)
            
        } catch {
            print("Error while fetching the data")
                
            return
        }
    }
    
    func deleteCache(month: String) {
        do {
            let fileURL = try FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent(month).appendingPathExtension("json")
                
            guard fileManager.fileExists(atPath: fileURL.path) else {
                return
            }
            try fileManager.removeItem(at: fileURL)
        } catch {
            print("Error while deleting the data")
        }
    }
        
}
