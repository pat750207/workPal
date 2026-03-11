// OrderLunchViewModel.swift
// WorkPal — Features/OrderLunch/ViewModels
//
// 原始：OrderLunchViewController 的業務邏輯
// ✅ selectedItemIndex → @Published selectedItem
// ✅ showAlert → @Published alertState

import Foundation

@MainActor
final class OrderLunchViewModel: ObservableObject {

    @Published private(set) var menuItems: [MenuItemModel] = MenuItemModel.sampleMenu
    @Published var selectedItem: MenuItemModel?
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert = false

    // MARK: - Intents（原 orderButtonTapped）

    func confirmOrder() {
        guard let item = selectedItem else {
            alertTitle = "No Selection"
            alertMessage = "Please select an item before ordering"
            showAlert = true
            return
        }
        alertTitle = "Order Successful"
        alertMessage = "You have successfully ordered \(item.name), price: $\(item.price)"
        showAlert = true
    }

    func selectItem(_ item: MenuItemModel) {
        selectedItem = item
    }

    var hasSelection: Bool { selectedItem != nil }
}
