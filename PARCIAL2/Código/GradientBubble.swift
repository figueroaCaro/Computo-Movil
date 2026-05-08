
import SwiftUI

struct GradientBubble: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            
            // 🌫️ Gradiente suave
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color(red: 0.75, green: 0.80, blue: 1.0).opacity(0.5),
                            Color(red: 0.85, green: 0.78, blue: 1.0).opacity(0.3)
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 160
                    )
                )
                .frame(width: 220, height: 220)
                .blur(radius: 10)
                .scaleEffect(animate ? 1.05 : 0.75) // 👈 respiración más tenue
                .animation(
                    .easeInOut(duration: 2.0) // 👈 más lento
                        .repeatForever(autoreverses: true),
                    value: animate
                )
            
            // ✨ brillo superior más suave
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 90, height: 90)
                .blur(radius: 18)
                .offset(x: -35, y: -45)
            
            // 🌊 glow secundario muy tenue
            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 200, height: 200)
                .blur(radius: 30)
        }
        .onAppear {
            animate = true
        }
    }
}
