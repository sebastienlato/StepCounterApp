# Repository Guidelines

## Project Structure & Module Organization
`StepCounterApp/` contains all SwiftUI sources, including `StepCounterAppApp.swift` for the app lifecycle and `ContentView.swift` for the primary UI. Shared assets live in `StepCounterApp/Assets.xcassets`; keep image or color catalogs grouped by feature to stay scalable. Interface configuration and capabilities are managed through `StepCounterApp.xcodeproj`, so create additional targets or resource bundles inside the Xcode project to keep build settings centralized.

## Build, Test, and Development Commands
- `open StepCounterApp.xcodeproj` launches the project in Xcode for simulator or device development.
- `xcodebuild -scheme StepCounterApp -destination 'platform=iOS Simulator,name=iPhone 15' clean build` provides a reproducible CI-friendly build.
- `xcodebuild test -scheme StepCounterApp -destination 'platform=iOS Simulator,name=iPhone 15'` runs the XCTest suite; pair it with `-resultBundlePath` when archiving logs from CI.

## Coding Style & Naming Conventions
Follow Swift API Design Guidelines: PascalCase for types, camelCase for properties and functions, and UPPER_SNAKE_CASE only for stringly-typed constants. Prefer SwiftUI view composition over large monolithic views; factor reusable components into dedicated structs under `StepCounterApp/`. Adopt four-space indentation and limit files to one top-level type when practical. There is no automated lint step yet, so mirror Xcode’s default formatting or enable SwiftFormat locally before submitting changes.

## Testing Guidelines
Unit and UI tests should live in `StepCounterAppTests/` or `StepCounterAppUITests/` (create the folders via Xcode if they are missing). Name test cases after the feature under test, e.g. `StepGoalViewModelTests`, and methods using the `test_whenCondition_expectOutcome` pattern for clarity. Ensure new features include at least one XCTest validating data flow or view state; document any gaps directly in the PR. Run `xcodebuild test` before pushing and include simulator/device variants when logic depends on HealthKit or Core Motion permissions.

## Commit & Pull Request Guidelines
Commit messages should remain imperative and scoped, for example `Add step count history chart`. Avoid bundling unrelated changes; split features and refactors into separate commits so reviewers can diff quickly. Pull requests need a short summary, a checklist of testing done (simulators, devices, CI), and references to tracking issues or tickets. Attach screenshots or screen recordings whenever UI elements change, and call out any required entitlement or provisioning profile updates.

## Configuration Tips
Health data access requires the `Privacy - Motion Usage Description` string in Info.plist; update localized copies if you modify wording. When adding frameworks such as CoreMotion or HealthKit, verify they are linked in the target’s `Frameworks, Libraries, and Embedded Content` section. Use separate build configurations for debug and release so motion-sensor mock data can be injected without affecting App Store builds.
