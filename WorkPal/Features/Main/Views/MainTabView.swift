// MainTabView.swift
// WorkPal — Features/Main/Views
//
// 原始：MainTabBarViewController.swift
// ✅ UITabBarController → TabView
// ✅ setupTabs() → TabView 內的 Tab
// ✅ UINavigationBarAppearance → .toolbarColorScheme
// ✅ logout → @EnvironmentObject loginViewModel

import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        TabView {
            // 原 PunchClockViewController
            NavigationStack {
                PunchClockView(viewModel: PunchClockSwiftUIViewModel())
                    .toolbar { logoutToolbar }
            }
            .tabItem {
                Label("Punch", systemImage: "clock.fill")
            }

            // 原 OrderLunchViewController
            NavigationStack {
                OrderLunchView(viewModel: OrderLunchViewModel())
            }
            .tabItem {
                Label("Lunch", systemImage: "fork.knife.circle.fill")
            }

            // 原 NoticeBoardViewController
            NavigationStack {
                NoticeBoardView(viewModel: NoticeBoardViewModel())
            }
            .tabItem {
                Label("Notices", systemImage: "megaphone.fill")
            }

            // 原 TakeLeaveViewController
            NavigationStack {
                TakeLeaveView(viewModel: TakeLeaveViewModel())
            }
            .tabItem {
                Label("Leave", systemImage: "figure.walk.circle.fill")
            }

            // 原 ProfilesViewController
            NavigationStack {
                ProfileView(viewModel: ProfileViewModel())
                    .toolbar { logoutToolbar }
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(Color(red: 0.3, green: 0.7, blue: 1.0))
        // 原 UIHelper.showDialog（logout）
        .alert("Log out", isPresented: $showLogoutAlert) {
            Button("logout", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    loginViewModel.logout()
                }
            }
            Button("cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    // 原 navigationItem.rightBarButtonItem（logout icon）
    @ToolbarContentBuilder
    private var logoutToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button { showLogoutAlert = true } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(LoginViewModel())
        .preferredColorScheme(.dark)
}
