import ActivityKit
import SwiftUI
import WidgetKit

struct RakeLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RakeActivityAttributes.self) { context in
            // Lock Screen banner
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.91, green: 0.86, blue: 0.78))
                        .frame(width: 44, height: 44)
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Rake • Mindful Drawing")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(context.state.patternName)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("\(context.state.minutesSpent)m calm")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
            }
            .padding(14)
            .background(Color(UIColor.secondarySystemBackground))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Rake", systemImage: "sparkles")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.minutesSpent)m")
                        .font(.system(size: 14, weight: .medium))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.statusText)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            } compactLeading: {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
            } compactTrailing: {
                Text("\(context.state.minutesSpent)m")
                    .font(.system(size: 11))
            } minimal: {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
            }
        }
    }
}

