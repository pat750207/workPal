// ProfileView.swift
// WorkPal — Features/Profile/Views
//
// 原始：ProfilesViewController.swift
// ✅ UIImagePickerController（Delegate）→ PhotosPicker
// ✅ UIAlertController（actionSheet）→ confirmationDialog
// ✅ userImageView → AsyncImage / Image

import SwiftUI
import PhotosUI

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // 原 userImageView
            Group {
                if let image = viewModel.userImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 160, height: 160)
            .clipShape(Circle())
            .shadow(color: .blue.opacity(0.3), radius: 10)

            // 原 changePhotoButton（actionSheet → confirmationDialog）
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Text("Change Photo")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    guard let newItem,
                          let data = try? await newItem.loadTransferable(type: Data.self),
                          let uiImage = UIImage(data: data)
                    else { return }
                    viewModel.updateImage(uiImage)
                }
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.08, green: 0.08, blue: 0.08).ignoresSafeArea())
        .navigationTitle("Profile")
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") {}
        } message: {
            Text("Image updated successfully.")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(viewModel: ProfileViewModel())
    }
    .preferredColorScheme(.dark)
}
