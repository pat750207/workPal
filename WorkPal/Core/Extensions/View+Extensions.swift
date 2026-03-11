// View+Extensions.swift
// WorkPal — Core/Extensions
//
// UIKit 對應：UIView 的 Category / Extension

import SwiftUI

extension View {

    // MARK: - 錯誤 Alert（對應 UIAlertController）
    func errorAlert(
        error: Binding<NetworkError?>,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        alert(
            "發生錯誤",
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { if !$0 { error.wrappedValue = nil } }
            ),
            actions: {
                Button("確定") { onDismiss?() }
            },
            message: {
                Text(error.wrappedValue?.localizedDescription ?? "未知錯誤")
            }
        )
    }

    // MARK: - Loading Overlay（對應 UIActivityIndicatorView）
    @ViewBuilder
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(1.5)
                }
            }
        }
    }

    // MARK: - 隱藏（對應 UIView.isHidden）
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide { self.hidden() } else { self }
    }
}
