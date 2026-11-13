import SwiftUI

struct StatsView: View {
    @ObservedObject var connectivity = WatchConnectivityManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Zen Stats")
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .foregroundColor(Color(red: 0.91, green: 0.86, blue: 0.78))

                _statRow(title: "Strokes", value: "\(connectivity.totalStrokes)")
                _statRow(title: "Streak", value: "\(connectivity.dayStreak) days")
                _statRow(title: "Achievements", value: "\(connectivity.unlockedAchievements)/25")
            }
            .padding(.horizontal, 4)
        }
    }

    private func _statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 3)
    }
}

