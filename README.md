# StepCounterApp

StepCounterApp is a SwiftUI iOS application that helps users track their daily steps, visualize progress toward a customizable goal, and receive notifications when the goal is met. The project is organized into view, view model, service, and store layers to keep UI and data responsibilities decoupled.

## Requirements
- Xcode 15 or later
- iOS 17 SDK
- Device or simulator with motion capabilities (step counting requires real hardware)

## Getting Started
1. Open the project with:
   ```bash
   open StepCounterApp.xcodeproj
   ```
2. Select the `StepCounterApp` scheme and run on a device or simulator.
3. The app requests Motion & Fitness permission on first launch. Allow access to see live step data.

## Project Structure
- `StepCounterApp/ContentView.swift`: Main SwiftUI screen showing progress, stats, and goal editor entry point.
- `StepCounterApp/ViewModels/StepCounterViewModel.swift`: Orchestrates pedometer data, goal tracking, and notifications.
- `StepCounterApp/Services/`: Lightweight wrappers around CoreMotion and UserNotifications.
- `StepCounterApp/Stores/GoalStatusStore.swift`: Persists daily goal achievement state using `UserDefaults`.
- `StepCounterApp/Views/GoalEditorView.swift`: Sheet for adjusting the daily step goal.

## Development Notes
- Update the `NSMotionUsageDescription` string in the project settings if you change how motion data is used.
- Use `xcodebuild -scheme StepCounterApp -destination 'platform=iOS Simulator,name=iPhone 15' build` for CI-friendly builds.
