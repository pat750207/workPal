// QuoteItem.swift
// WorkPal — Core/Models
//
// 原始：CompanyApp/Model/Quote.swift

import Foundation

struct QuoteItem: Codable {
    let quote: String
}

struct QuoteResponse: Codable {
    let quotes: [QuoteItem]
}
