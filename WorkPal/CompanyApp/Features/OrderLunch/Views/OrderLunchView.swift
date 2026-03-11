// OrderLunchView.swift
// WorkPal — Features/OrderLunch/Views
//
// 原始：OrderLunchViewController.swift + MenuItemCell
// ✅ UITableView + delegate → List + ForEach
// ✅ didSelectRowAt → onTapGesture / selection binding
// ✅ MenuItemCell（programmatic UIView）→ SwiftUI Row
// ✅ UIView.animate（selection）→ withAnimation

import SwiftUI

struct OrderLunchView: View {

    @ObservedObject var viewModel: OrderLunchViewModel

    var body: some View {
        VStack(spacing: 0) {
            // 原 headerLabel + titleLabel
            VStack(spacing: 8) {
                Text("Today's Menu")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                // 原 deadlineLabel
                Text("Order Deadline: 10:30 AM")
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }
            .padding()

            // 原 tableView
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.menuItems) { item in
                        MenuItemRow(
                            item: item,
                            isSelected: viewModel.selectedItem?.id == item.id
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.selectItem(item)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            // 原 orderButton
            Button {
                viewModel.confirmOrder()
            } label: {
                Text("Confirm Order")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding()
        }
        .background(Color(red: 0.08, green: 0.08, blue: 0.08).ignoresSafeArea())
        .navigationTitle("Lunch")
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

// MARK: - MenuItemRow（原 MenuItemCell）
struct MenuItemRow: View {
    let item: MenuItemModel
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // 原 menuImageView
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.25))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }

                VStack(alignment: .leading, spacing: 6) {
                    // 原 nameLabel
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(.white)

                    // 原 descriptionLabel
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(2)

                    // 原 priceLabel
                    Text("$\(item.price)")
                        .font(.headline)
                        .foregroundStyle(.blue)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected
                          ? Color(red: 0.2, green: 0.2, blue: 0.25)
                          : Color(red: 0.15, green: 0.15, blue: 0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color(red: 0.3, green: 0.7, blue: 1.0) : .clear, lineWidth: 1)
                    )
            )
            // 原 selectionIndicator
            .overlay(alignment: .leading) {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .frame(width: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        OrderLunchView(viewModel: OrderLunchViewModel())
    }
    .preferredColorScheme(.dark)
}
