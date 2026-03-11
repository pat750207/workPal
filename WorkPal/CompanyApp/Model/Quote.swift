//
//  Quote.swift
//  PunchClock


struct Quote: Codable {
    
    let quote: String
}

struct Quotes: Codable {
    let quotes: [Quote]
}
