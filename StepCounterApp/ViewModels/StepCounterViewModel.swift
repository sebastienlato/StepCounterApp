import Combine
import CoreMotion
import Foundation

final class StepCounterViewModel: ObservableObject {
    @Published private(set) var todaySteps: Int = 0
    @Published private(set) var isAuthorized: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var goalAchievedToday: Bool = false

    private let pedometerService: PedometerServiceProtocol
    private let notificationService: NotificationServiceProtocol
    private let goalStatusStore: GoalStatusStoring
    private let calendar: Calendar

    private var dailyGoal: Int = 10_000
    private var hasStarted = false

    init(
        pedometerService: PedometerServiceProtocol? = nil,
        notificationService: NotificationServiceProtocol? = nil,
        goalStatusStore: GoalStatusStoring? = nil,
        calendar: Calendar = .current
    ) {
        self.pedometerService = pedometerService ?? PedometerService()
        self.notificationService = notificationService ?? NotificationService()
        self.goalStatusStore = goalStatusStore ?? GoalStatusStore()
        self.calendar = calendar
    }

    deinit {
        pedometerService.stopUpdates()
    }

    func start(dailyGoal: Int) {
        self.dailyGoal = dailyGoal
        goalStatusStore.resetIfNeeded(calendar: calendar)
        goalAchievedToday = goalStatusStore.goalAchievedToday

        guard !hasStarted else {
            evaluateGoalAchievement()
            return
        }

        hasStarted = true
        notificationService.requestAuthorization()
        startTracking()
    }

    func updateDailyGoal(to newGoal: Int) {
        dailyGoal = newGoal
        evaluateGoalAchievement()
    }

    private func startTracking() {
        guard pedometerService.isStepCountingAvailable else {
            errorMessage = "Step counting is not available on this device."
            return
        }

        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        pedometerService.queryData(from: startOfDay, to: now) { [weak self] data, error in
            guard let self else { return }
            Task { @MainActor in
                self.handlePedometerResult(data: data, error: error)
            }
        }

        pedometerService.startUpdates(from: startOfDay) { [weak self] data, error in
            guard let self else { return }
            Task { @MainActor in
                self.handlePedometerResult(data: data, error: error)
            }
        }
    }

    private func handlePedometerResult(data: CMPedometerData?, error: Error?) {
        if error != nil {
            errorMessage = "Please enable Motion & Fitness access in Settings."
            isAuthorized = false
            todaySteps = 0
            return
        }

        guard let data else { return }

        isAuthorized = true
        errorMessage = nil
        todaySteps = data.numberOfSteps.intValue
        evaluateGoalAchievement()
    }

    private func evaluateGoalAchievement() {
        goalStatusStore.resetIfNeeded(calendar: calendar)
        let alreadyAchieved = goalStatusStore.goalAchievedToday

        if todaySteps >= dailyGoal && !alreadyAchieved {
            goalStatusStore.markGoalAchieved()
            goalAchievedToday = true
            notificationService.sendGoalAchievedNotification(goal: dailyGoal)
        } else {
            goalAchievedToday = goalStatusStore.goalAchievedToday
        }
    }
}
