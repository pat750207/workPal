// ProfileViewModel.swift
// WorkPal — Features/Profile/ViewModels
//
// 原始：ProfilesViewController 的業務邏輯
// ✅ UIImagePickerController（Delegate）→ PhotosPicker binding
// ✅ saveImage / getSavedImage → @Published + FileManager

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var userImage: UIImage?
    @Published var showImageSourcePicker = false
    @Published var showCamera = false
    @Published var showPhotoLibrary = false
    @Published var showSuccessAlert = false

    init() {
        loadSavedImage()
    }

    // MARK: - Intents（原 changePhotoButtonClicked + selectImageFrom）

    func updateImage(_ image: UIImage) {
        userImage = image
        _ = saveImage(image)
        showSuccessAlert = true
    }

    // MARK: - Private（原 saveImage / getSavedImage）

    private func saveImage(_ image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData(),
              let dir = try? FileManager.default.url(
                for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        else { return false }

        do {
            try data.write(to: dir.appendingPathComponent("user.png"))
            return true
        } catch {
            return false
        }
    }

    private func loadSavedImage() {
        guard let dir = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        else { return }

        let path = dir.appendingPathComponent("user.png").path
        userImage = UIImage(contentsOfFile: path)
    }
}
