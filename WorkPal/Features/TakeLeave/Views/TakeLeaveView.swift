// TakeLeaveView.swift
// WorkPal — Features/TakeLeave/Views
//
// 原始：TakeLeaveViewController.swift
// ✅ MyPicker（Delegate）→ Picker binding
// ✅ UIDatePicker（inputView）→ DatePicker
// ✅ UITextView placeholder → TextEditor + prompt overlay
// ✅ touchesEnded → .onTapGesture + FocusState

import SwiftUI

struct TakeLeaveView: View {

    @ObservedObject var viewModel: TakeLeaveViewModel
    @FocusState private var isReasonFocused: Bool

    var body: some View {
        Form {
            // 原 leaveTypePickerView（MyPicker + Delegate）
            Section("Leave Type") {
                Picker("Type", selection: $viewModel.leaveRequest.leaveType) {
                    ForEach(LeaveType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }

            // 原 startTimeTextField + endTimeTextField（UIDatePicker inputView）
            Section("Duration") {
                DatePicker("Start Time",
                           selection: $viewModel.leaveRequest.startTime,
                           displayedComponents: [.date, .hourAndMinute])

                DatePicker("End Time",
                           selection: $viewModel.leaveRequest.endTime,
                           in: viewModel.leaveRequest.startTime...,
                           displayedComponents: [.date, .hourAndMinute])
            }

            // 原 leaveReasonTextView（UITextViewDelegate placeholder）
            Section("Leave Reason") {
                ZStack(alignment: .topLeading) {
                    if viewModel.leaveRequest.reason.isEmpty && !isReasonFocused {
                        Text("Leave reason")
                            .foregroundStyle(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $viewModel.leaveRequest.reason)
                        .focused($isReasonFocused)
                        .frame(minHeight: 100)
                }
            }

            // 原 sendButtonClicked
            Section {
                Button {
                    isReasonFocused = false
                    viewModel.submitLeave()
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .listRowBackground(
                    viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.5)
                )
                .disabled(!viewModel.isFormValid)
            }
        }
        .navigationTitle("Leave")
        // 原 UIHelper.showDialog（success）
        .alert("Sent successfully", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { viewModel.resetForm() }
        }
        // 原 UIHelper.showDialog（error）
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    NavigationStack {
        TakeLeaveView(viewModel: TakeLeaveViewModel())
    }
    .preferredColorScheme(.dark)
}
