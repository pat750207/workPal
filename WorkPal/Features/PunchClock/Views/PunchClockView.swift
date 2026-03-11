// PunchClockView.swift
// WorkPal — Features/PunchClock/Views
//
// 原始：PunchClockViewController.swift
// ✅ @IBOutlet → @Published state from ViewModel
// ✅ Combine .sink → automatic SwiftUI binding
// ✅ UIView.animate / CAEmitterLayer → withAnimation
// ✅ NSLayoutConstraint → VStack/HStack/Spacer
// ✅ viewWillAppear → .onAppear

import SwiftUI

struct PunchClockView: View {

    @ObservedObject var viewModel: PunchClockSwiftUIViewModel

    @State private var showCheckInSuccess = false
    @State private var showCheckOutSuccess = false
    @State private var checkInScale: CGFloat = 1.0
    @State private var checkOutScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.08).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // 日期與星期（原 dateLabel + weekdayLabel）
                    dateHeader

                    // 每日金句（原 quoteTextField）
                    quoteSection

                    // 打卡按鈕區
                    Spacer().frame(height: 16)
                    punchInButton
                    workingHourInfo
                    punchOutButton
                    captionText

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Punch")
        .navigationBarTitleDisplayMode(.inline)
        // 原 viewWillAppear
        .onAppear { viewModel.checkAutoPunchOut() }
        // 原 toolbar → Settings
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingView(viewModel: SettingSwiftUIViewModel())
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        // 原 displayAlert（恭喜下班）
        .alert("Congratulations", isPresented: $viewModel.showPunchOutCongrats) {
            Button("YAY") { viewModel.resetAfterPunchOut() }
        } message: {
            Text("Hurry off work!")
        }
    }

    // MARK: - Subviews

    private var dateHeader: some View {
        VStack(spacing: 4) {
            Text(viewModel.weekDayStr)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
            Text(viewModel.dateStr)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }

    private var quoteSection: some View {
        Text(viewModel.quoteText)
            .font(.callout.italic())
            .foregroundStyle(.white.opacity(0.7))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }

    // 原 checkInButton（TimeButton + touchDownRepeat）
    private var punchInButton: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                checkInScale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3)) { checkInScale = 1.0 }
            }
            viewModel.punchIn()
            showCheckInSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showCheckInSuccess = false }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: viewModel.isPunchedIn ? "checkmark.circle.fill" : "clock.fill")
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(viewModel.isPunchedIn ? "Punched In" : "Punch In")
                        .font(.headline)
                    Text(viewModel.punchInTimeStr ?? viewModel.currentTimeStr)
                        .font(.title.monospacedDigit())
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                LinearGradient(
                    colors: viewModel.isPunchedIn
                        ? [Color.green.opacity(0.6), Color.green.opacity(0.3)]
                        : [Color.blue.opacity(0.6), Color.blue.opacity(0.3)],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .blue.opacity(0.4), radius: 12, y: 4)
        }
        .scaleEffect(checkInScale)
        .disabled(viewModel.isPunchedIn)
        .overlay(alignment: .bottom) {
            if showCheckInSuccess {
                Text("Punch In Success!")
                    .font(.callout.bold())
                    .foregroundStyle(.green)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .offset(y: 36)
            }
        }
    }

    // 原 workingHourStack + workingHourLabel
    private var workingHourInfo: some View {
        Group {
            if viewModel.isPunchedIn {
                Text(viewModel.workingHourStr)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.isPunchedIn)
    }

    // 原 checkOutButton
    private var punchOutButton: some View {
        Group {
            if viewModel.shouldShowCheckOutButton {
                Button {
                    withAnimation(.spring(response: 0.3)) { checkOutScale = 1.2 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3)) { checkOutScale = 1.0 }
                    }
                    viewModel.punchOut()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "moon.fill")
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("Punch Out")
                                .font(.headline)
                            Text(viewModel.currentTimeStr)
                                .font(.title.monospacedDigit())
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.6), Color.orange.opacity(0.3)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .orange.opacity(0.4), radius: 12, y: 4)
                }
                .scaleEffect(checkOutScale)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.easeInOut(duration: 0.5).delay(0.15), value: viewModel.shouldShowCheckOutButton)
    }

    // 原 captionLabel
    private var captionText: some View {
        Group {
            if viewModel.shouldShowCaption {
                Text("Double-tap to punch in")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .animation(.easeInOut, value: viewModel.shouldShowCaption)
    }
}

#Preview {
    NavigationStack {
        PunchClockView(viewModel: PunchClockSwiftUIViewModel())
    }
    .preferredColorScheme(.dark)
}
