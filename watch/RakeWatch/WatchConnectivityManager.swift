import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()

    @Published var dailyPatternName: String = "Zen Waves"
    @Published var totalStrokes: Int = 120
    @Published var dayStreak: Int = 3
    @Published var unlockedAchievements: Int = 4

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let pattern = applicationContext["dailyPattern"] as? String {
                self.dailyPatternName = pattern
            }
            if let strokes = applicationContext["totalStrokes"] as? Int {
                self.totalStrokes = strokes
            }
            if let streak = applicationContext["dayStreak"] as? Int {
                self.dayStreak = streak
            }
            if let ach = applicationContext["achievements"] as? Int {
                self.unlockedAchievements = ach
            }
        }
    }
}

