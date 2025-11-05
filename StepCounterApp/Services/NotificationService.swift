import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization()
    func sendGoalAchievedNotification(goal: Int)
}

final class NotificationService: NotificationServiceProtocol {
    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            // Authorization result is ignored intentionally; UI reflects access status via pedometer callbacks.
        }
    }

    func sendGoalAchievedNotification(goal: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Goal Achieved! 🎉"
        content.body = "You've reached your daily goal of \(goal) steps!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        notificationCenter.add(request)
    }
}
