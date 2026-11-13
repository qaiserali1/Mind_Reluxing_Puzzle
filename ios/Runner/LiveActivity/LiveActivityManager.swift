import ActivityKit
import Foundation

class LiveActivityManager {
    static let shared = LiveActivityManager()

    func startDrawingActivity(patternName: String) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = RakeActivityAttributes(gardenName: "Zen Sanctuary")
        let initialState = RakeActivityAttributes.ContentState(
            patternName: patternName,
            minutesSpent: 1,
            statusText: "Drawing in sand..."
        )

        do {
            _ = try Activity.request(attributes: attributes, contentState: initialState, pushType: nil)
        } catch {}
    }

    func stopDrawingActivity() {
        Task {
            for activity in Activity<RakeActivityAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}

