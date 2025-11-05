import SwiftUI

struct ContentView: View {
    @AppStorage("dailyGoal") private var dailyGoal = 10_000
    @StateObject private var viewModel: StepCounterViewModel
    @State private var showingGoalEditor = false

    init(viewModel: StepCounterViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? StepCounterViewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.isAuthorized {
                        StepProgressRing(
                            steps: viewModel.todaySteps,
                            dailyGoal: dailyGoal,
                            progress: progressRatio
                        )
                        .padding(.top, 32)

                        VStack(spacing: 16) {
                            GoalSummaryCard(
                                dailyGoal: dailyGoal,
                                onEditTapped: { showingGoalEditor = true }
                            )

                            InfoCard(
                                title: "Remaining",
                                value: "\(max(dailyGoal - viewModel.todaySteps, 0))",
                                systemImage: "figure.walk",
                                accent: .green
                            )

                            if viewModel.goalAchievedToday {
                                SuccessCard(message: "Goal achieved!")
                            }
                        }
                    } else if let error = viewModel.errorMessage {
                        ErrorStateView(
                            title: "Unable to Access Step Data",
                            message: error
                        )
                        .padding(.top, 60)
                    } else {
                        ProgressView()
                            .padding(.top, 60)
                    }

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Steps")
        }
        .onAppear {
            viewModel.start(dailyGoal: dailyGoal)
        }
        .onChange(of: dailyGoal) { _, newValue in
            viewModel.updateDailyGoal(to: newValue)
        }
        .sheet(isPresented: $showingGoalEditor) {
            GoalEditorView(
                dailyGoal: $dailyGoal,
                onSave: { newGoal in
                    viewModel.updateDailyGoal(to: newGoal)
                }
            )
        }
    }

    private var progressRatio: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(viewModel.todaySteps) / Double(dailyGoal), 1.0)
    }
}

#Preview {
    ContentView()
}

private struct StepProgressRing: View {
    let steps: Int
    let dailyGoal: Int
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)

            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: steps)

            VStack(spacing: 8) {
                Text("\(steps)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())

                Text("of \(dailyGoal)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 260, height: 260)
    }
}

private struct GoalSummaryCard: View {
    let dailyGoal: Int
    let onEditTapped: () -> Void

    var body: some View {
        Button(action: onEditTapped) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Goal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(dailyGoal)")
                        .font(.title2.bold())
                }
                Spacer()
                Image(systemName: "flag.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct InfoCard: View {
    let title: String
    let value: String
    let systemImage: String
    let accent: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.title2.bold())
            }
            Spacer()
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(accent)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct SuccessCard: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.green)
            Text(message)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct ErrorStateView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)

            Text(title)
                .font(.title2.bold())

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
