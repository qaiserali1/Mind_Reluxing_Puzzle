import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BreatheView()
                .tabItem {
                    Label("Breathe", systemImage: "circle.dotted")
                }

            InspirationsView()
                .tabItem {
                    Label("Inspiration", systemImage: "sparkles")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
        }
    }
}

