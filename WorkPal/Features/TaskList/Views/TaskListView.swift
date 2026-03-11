// TaskListView.swift
// WorkPal — Features/TaskList/Views
//
// UIKit 對應：TaskListViewController + UITableView + UISearchController
// ✅ View 零邏輯 — 所有狀態來自 ViewModel
// ✅ viewDidLoad → .onAppear
// ✅ UITableView → List
// ✅ UISearchController → .searchable

import SwiftUI

struct TaskListView: View {

    @ObservedObject var viewModel: TaskListViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.tasks.isEmpty {
                loadingView
            } else if viewModel.filteredTasks.isEmpty {
                emptyStateView
            } else {
                taskList
            }
        }
        .navigationTitle("WorkPal")
        .navigationBarTitleDisplayMode(.large)
        .toolbar { toolbarContent }
        // UIKit 對應：viewDidLoad 的初始化邏輯
        .task { await viewModel.loadTasks() }
        // UIKit 對應：UISearchController
        .searchable(text: $viewModel.searchText, prompt: "搜尋任務")
        // 篩選 Picker
        .safeAreaInset(edge: .top) { filterBar }
        // 錯誤 Alert（對應 UIAlertController）
        .errorAlert(error: $viewModel.errorMessage)
        // 新增任務 Sheet
        .sheet(isPresented: $viewModel.showCreateTask) {
            CreateTaskView(viewModel: viewModel)
        }
        .loadingOverlay(isLoading: viewModel.isLoading)
    }

    // MARK: - Subviews

    private var taskList: some View {
        List {
            // 統計 Header
            Section {
                statsHeader
            }
            // 任務列表
            Section {
                ForEach(viewModel.filteredTasks) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task) {
                            Task { await viewModel.toggleComplete(task: task) }
                        }
                    }
                }
                // UIKit 對應：swipeActionsConfiguration（左滑刪除）
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let task = viewModel.filteredTasks[index]
                        Task { await viewModel.deleteTask(task) }
                    }
                }
            } header: {
                Text("任務清單")
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            // UIKit 對應：UIRefreshControl
            await viewModel.loadTasks()
        }
        // Navigation destination（對應 push segue）
        .navigationDestination(for: TaskItem.self) { task in
            TaskDetailView(task: task)
        }
        // 動畫（對應 UIView.animate）
        .animation(.easeInOut, value: viewModel.filteredTasks)
    }

    private var statsHeader: some View {
        HStack(spacing: 16) {
            StatBadge(count: viewModel.pendingCount, label: "待辦", color: .blue)
            StatBadge(count: viewModel.completedCount, label: "完成", color: .green)
        }
        .padding(.vertical, 4)
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TaskListViewModel.FilterOption.allCases, id: \.self) { option in
                    FilterChip(
                        title: option.rawValue,
                        isSelected: viewModel.selectedFilter == option
                    ) {
                        withAnimation { viewModel.selectedFilter = option }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(.bar)
    }

    private var loadingView: some View {
        ProgressView("載入中...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "沒有任務",
            systemImage: "checkmark.circle",
            description: Text("點擊右上角 + 新增任務")
        )
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                viewModel.showCreateTask = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// MARK: - TaskRowView
struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // UIKit 對應：UIButton（勾選）
            Button(action: onToggle) {
                Image(systemName: task.statusSFSymbol)
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if let due = task.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: task.isOverdue ? "exclamationmark.triangle.fill" : "calendar")
                            .font(.caption2)
                        Text(due.displayString)
                            .font(.caption2)
                    }
                    .foregroundStyle(task.isOverdue ? .red : .secondary)
                }
            }

            Spacer()

            // Priority Badge
            Text(task.priority.displayName)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color(task.priority.color).opacity(0.2))
                .foregroundStyle(Color(task.priority.color))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

// MARK: - StatBadge
private struct StatBadge: View {
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)").font(.title2.bold()).foregroundStyle(color)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - FilterChip
private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TaskListView(viewModel: {
            let vm = TaskListViewModel(service: MockTaskService())
            return vm
        }())
    }
}
