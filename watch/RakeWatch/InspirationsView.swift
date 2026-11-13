import SwiftUI

struct InspirationsView: View {
    @ObservedObject var connectivity = WatchConnectivityManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Today's Pattern")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)

                Text(connectivity.dailyPatternName)
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color(red: 0.91, green: 0.86, blue: 0.78))
                    .multilineTextAlignment(.center)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.91, green: 0.86, blue: 0.78))
                        .frame(width: 80, height: 80)

                    Image(systemName: "sparkles")
                        .font(.system(size: 28))
                        .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
                }

                Text("Open iPhone to draw")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
    }
}

