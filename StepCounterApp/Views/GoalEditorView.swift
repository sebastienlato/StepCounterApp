import SwiftUI

struct GoalEditorView: View {
    @Binding var dailyGoal: Int
    let onSave: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var tempGoal: Int

    init(dailyGoal: Binding<Int>, onSave: @escaping (Int) -> Void) {
        self._dailyGoal = dailyGoal
        self.onSave = onSave
        self._tempGoal = State(initialValue: dailyGoal.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("\(tempGoal)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())
                        Text("steps per day")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    adjustmentControls
                    commonGoalsList

                    Spacer(minLength: 40)
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Daily Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dailyGoal = tempGoal
                        onSave(tempGoal)
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }

    private var adjustmentControls: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    tempGoal = max(3000, tempGoal - 500)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    tempGoal = min(12000, tempGoal + 500)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 40)

            Text("Adjust in increments of 500")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var commonGoalsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Common Goals")
                .font(.headline)
                .padding(.horizontal)

            ForEach([3000, 5000, 7500, 10000, 12000], id: \.self) { goal in
                Button {
                    tempGoal = goal
                } label: {
                    HStack {
                        Text("\(goal) steps")
                            .font(.body)
                        Spacer()
                        if tempGoal == goal {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
        }
        .padding(.top, 20)
    }
}
