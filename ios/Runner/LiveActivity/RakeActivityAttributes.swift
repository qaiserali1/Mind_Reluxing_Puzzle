import ActivityKit
import Foundation

struct RakeActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var patternName: String
        var minutesSpent: Int
        var statusText: String
    }

    var gardenName: String
}

