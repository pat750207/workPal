//
//  JSONUtils.swift
//  eInfoSys
//
//  Created by Pat Chang (XN-188Asia) on 2025/2/21.
//

import Foundation

func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}

func getQuote(jsonData: Data) -> String? {
    let randomInt = 0
    do {
        let decodedData = try JSONDecoder().decode(Quotes.self, from: jsonData)
        return decodedData.quotes[randomInt].quote
    } catch {
        print("error: \(error)")
    }
    return nil
    
}

func getNoticeBoard(jsonData: Data) -> [NoticeBoard]? {
    
    do {
        let decodedData = try JSONDecoder().decode(NoticeBoards.self, from: jsonData)
        return decodedData.noticeBoards
    } catch {
        print("error: \(error)")
    }
    return nil
    
}
