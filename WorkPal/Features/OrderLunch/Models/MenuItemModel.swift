// MenuItemModel.swift
// WorkPal — Features/OrderLunch/Models
//
// 原始：OrderLunchViewController 內的 MenuItem struct
// ✅ 加入 Identifiable

import Foundation

struct MenuItemModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let price: Int
    let image: String
    let description: String
}

extension MenuItemModel {
    static let sampleMenu: [MenuItemModel] = [
        MenuItemModel(name: "Fried Chicken Rice", price: 85, image: "chicken_rice",
                      description: "Tender fried chicken with special sauce"),
        MenuItemModel(name: "Beef Rice Bowl", price: 95, image: "beef_rice",
                      description: "Fresh beef slices with green onions"),
        MenuItemModel(name: "Salmon Sushi Rice", price: 90, image: "salmon_sushi",
                      description: "Premium salmon with sushi rice"),
        MenuItemModel(name: "Vegetarian Noodles", price: 75, image: "veggie_noodles",
                      description: "Fresh vegetables with healthy noodles"),
        MenuItemModel(name: "Thai Spicy Noodle Soup", price: 85, image: "thai_noodles",
                      description: "Mildly spicy Thai soup with pork"),
    ]
}
