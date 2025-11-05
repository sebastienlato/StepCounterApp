import Foundation

protocol GoalStatusStoring {
    var goalAchievedToday: Bool { get }
    func markGoalAchieved()
    func resetIfNeeded(calendar: Calendar)
}

final class GoalStatusStore: GoalStatusStoring {
    private enum Keys {
        static let goalAchieved = "goalAchievedToday"
        static let lastReset = "lastResetDate"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var goalAchievedToday: Bool {
        defaults.bool(forKey: Keys.goalAchieved)
    }

    func markGoalAchieved() {
        defaults.set(true, forKey: Keys.goalAchieved)
        defaults.set(Date(), forKey: Keys.lastReset)
    }

    func resetIfNeeded(calendar: Calendar) {
        let lastReset = defaults.object(forKey: Keys.lastReset) as? Date ?? .distantPast
        guard !calendar.isDateInToday(lastReset) else { return }

        defaults.set(false, forKey: Keys.goalAchieved)
        defaults.set(Date(), forKey: Keys.lastReset)
    }
}
