// NetworkError.swift
// WorkPal — Core/Network
//
// 統一錯誤定義，方便 ViewModel 用 Result type 回傳

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(statusCode: Int)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:        return "無效的 URL"
        case .noData:            return "沒有收到資料"
        case .decodingFailed:    return "資料解析失敗"
        case .serverError(let code): return "伺服器錯誤：\(code)"
        case .unknown(let msg):  return msg
        }
    }
}
