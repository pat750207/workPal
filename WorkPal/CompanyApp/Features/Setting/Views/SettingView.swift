// SettingView.swift
// WorkPal — Features/Setting/Views
//
// 原始：SettingViewController.swift
// ✅ @IBOutlet + Combine .assign → @Published direct binding
// ✅ IBAction add/minus → Button + ViewModel intent
// ✅ UISwitch → Toggle binding
// ✅ viewWillDisappear → .onDisappear

import SwiftUI

struct SettingView: View {

    @ObservedObject var viewModel: SettingSwiftUIViewModel

    var body: some View {
        Form {
            // 工時設定（原 hoursLabel + addBtn + minusBtn）
            Section("Working Hours") {
                HStack {
                    // 原 minusBtn
                    Button {
                        viewModel.minusHours()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(viewModel.isMinusEnabled ? .blue : .gray)
                    }
                    .disabled(!viewModel.isMinusEnabled)
                    .buttonStyle(.plain)

                    Spacer()

                    // 原 hoursLabel
                    Text("\(viewModel.displayHours) hours")
                        .font(.title2.monospacedDigit().bold())

                    Spacer()

                    // 原 addBtn
                    Button {
                        viewModel.addHours()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(viewModel.isAddEnabled ? .blue : .gray)
                    }
                    .disabled(!viewModel.isAddEnabled)
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
            }

            // 推播設定（原 offWorkPushSwitch + autoPunchOutSwitch）
            Section("Notifications") {
                // 原 offWorkPushSwitch
                Toggle("Off-work Push Notification", isOn: $viewModel.isOffWorkPushOn)
                    .onChange(of: viewModel.isOffWorkPushOn) { _, isOn in
                        if isOn { viewModel.togglePush() }
                    }

                // 原 autoPunchOutSwitch
                Toggle("Auto Punch Out", isOn: $viewModel.isAutoPunchOutOn)
            }

            // 打卡紀錄（原 goSetting → RecordList）
            Section {
                NavigationLink {
                    RecordListView(viewModel: RecordListViewModel())
                } label: {
                    Label("Punch Records", systemImage: "list.clipboard")
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        // 原 viewWillAppear → syncPushStatus
        .onAppear { viewModel.syncPushStatus() }
        // 原 viewWillDisappear → saveDataToUserDefault
        .onDisappear { viewModel.saveSettings() }
    }
}

#Preview {
    NavigationStack {
        SettingView(viewModel: SettingSwiftUIViewModel())
    }
    .preferredColorScheme(.dark)
}
