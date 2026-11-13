import SwiftUI
import WatchKit

struct BreatheView: View {
    @State private var isBreathing = false
    @State private var scale: CGFloat = 0.5
    @State private var breathText = "Inhale..."

    let timer = Timer.publish(every: 4.0, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 8) {
            Text(breathText)
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundColor(Color(red: 0.91, green: 0.86, blue: 0.78))

            ZStack {
                Circle()
                    .stroke(Color(red: 0.50, green: 0.66, blue: 0.56).opacity(0.4), lineWidth: 4)
                    .frame(width: 90, height: 90)

                Circle()
                    .fill(Color(red: 0.91, green: 0.86, blue: 0.78).opacity(0.85))
                    .frame(width: 70, height: 70)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 4.0), value: scale)
            }

            Text("60s Zen Breathe")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .onAppear {
            startBreathing()
        }
        .onReceive(timer) { _ in
            toggleBreathCycle()
        }
    }

    private func startBreathing() {
        isBreathing = true
        scale = 1.1
        breathText = "Inhale..."
        WKInterfaceDevice.current().play(.directionUp)
    }

    private func toggleBreathCycle() {
        if isBreathing {
            scale = 0.5
            breathText = "Exhale..."
            WKInterfaceDevice.current().play(.directionDown)
            isBreathing = false
        } else {
            scale = 1.1
            breathText = "Inhale..."
            WKInterfaceDevice.current().play(.directionUp)
            isBreathing = true
        }
    }
}

