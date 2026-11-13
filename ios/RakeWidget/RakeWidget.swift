import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), patternName: "Zen Waves", isPremium: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), patternName: "Water Ripples", isPremium: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.app.rake.widget")
        let pattern = sharedDefaults?.string(forKey: "daily_pattern_name") ?? "Zen Waves"
        let premium = sharedDefaults?.bool(forKey: "is_premium") ?? false

        let entry = SimpleEntry(date: Date(), patternName: pattern, isPremium: premium)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let patternName: String
    let isPremium: Bool
}

struct RakeWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(red: 0.91, green: 0.86, blue: 0.78) // Sand base #E8DCC8

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Rake")
                        .font(.custom("CormorantGaramond-SemiBold", size: 20))
                        .foregroundColor(Color(red: 0.24, green: 0.21, blue: 0.16))
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
                }

                Spacer()

                Text("Today's Inspiration")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(red: 0.55, green: 0.49, blue: 0.42))

                Text(entry.patternName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.24, green: 0.21, blue: 0.16))

                Text("Tap to draw")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(Color(red: 0.50, green: 0.66, blue: 0.56))
            }
            .padding(14)
        }
        .widgetURL(URL(string: "rake://garden"))
    }
}

@main
struct RakeWidget: Widget {
    let kind: String = "RakeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RakeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Rake Zen Garden")
        .description("Daily calm inspiration right on your Home Screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

