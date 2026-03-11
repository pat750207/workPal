//
//  CompanyAppManager.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2025/1/23.
//

import Foundation

class CompanyAppManager {
    
    enum CompanyApiKey: String {
        
        case dataUpdate
        case login
        case documentUpload
        case takeLeave
    }
    
    
    static let shared = CompanyAppManager()
    
    var token: String?
    
//    private func getDomain() -> String?
//    {
//        switch ProjectConfig.buildEnv {
//        case .DEV:
//            return "http://spi-app-service.188bet.test"
//        case .QAT:
//            return "https://spi-app-service.188bet.green"
//        case .UAT:
//            return "https://spi-app-service.188bet.blue"
//        case .PROD, .PROD_PREV:
//            return "https://spi-app-service.fesofts.com"
//        case .RED:
//            return "https://spi-app-service.188bet.red"
//        default:
//            break
//        }
//        return ""
//    }
    
    func companyApiFire(apiKey: CompanyApiKey, body: [String : Any] = [:], completion: @escaping (Bool , Any) -> Void) {
//        guard let domain = getDomain() else { return }
        
        let url = URL(string: "https://spi-app-service.188bet.green/api/\(apiKey.rawValue)")!
        print("domain url==========>>>>>>\(url)")
            
        // Create the request parameters
        var parameters: [String: Any] = [:]
        
        if apiKey == .dataUpdate {
            // Get system information dynamically
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
//            let deviceModel = UIDevice.current.model
//            let deviceOS = "iOS\(UIDevice.current.systemVersion)"
            let productId = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
            
            parameters = [
                "id": String(Int(Date().timeIntervalSince1970)),
                "appVersion": appVersion,
//                "model": deviceModel,
//                "deviceOS": deviceOS,
                "productId": productId,
                "pushToken": ""
            ]
        }else{
            parameters = [
                "id": String(Int(Date().timeIntervalSince1970)),
                "body": body
            ]
        }
        
        do {
            // Convert parameters to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            // Create a URLRequest object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            request.timeoutInterval = 10.0
            print(parameters)
            
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error occur: error calling GET - \(String(describing: error))")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            if data.count == 0 {
                                completion(true, httpResponse.statusCode)
                            } else {
                                do {
                                    // Parse the JSON response
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        // Call the success block with the parsed value
                                        completion(true, json)
                                    }
                                } catch {
                                    // Call the failure block if JSON parsing fails
                                    print("Error : Call the failure block if JSON parsing fails")
                                }
                            }
                        }
                    }else{
                        completion(false, httpResponse.statusCode)
                    }
                }
            }
            
            // Start the task
            task.resume()
            
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
}
