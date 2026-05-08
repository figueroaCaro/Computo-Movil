import SwiftUI

struct MorphingMoodOrb: View {
    var moodValue: Double   // 0 = muy mal, 1 = muy bien
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            
            let spikeAmount = pow(1.0 - moodValue, 0.62)
            let breathe = 0.5 + 0.5 * sin(t * 1.7)
            let formPhase = 0.5 + 0.5 * sin(t * 0.45)
            let attraction = 0.06 + (0.10 * breathe) + (0.24 * pow(moodValue, 1.6))
            
            ZStack {
                MoodBlobShape(
                    irregularity: spikeAmount,
                    attraction: attraction,
                    formPhase: formPhase
                )
                .fill(
                    RadialGradient(
                        colors: [
                            softTopColor.opacity(0.95),
                            softMidColor.opacity(0.90),
                            softBottomColor.opacity(0.85)
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 130
                    )
                )
                .blur(radius: 0.3)
                
                // ✨ Borde suave (no rígido)
                .overlay(
                    MoodBlobShape(
                        irregularity: spikeAmount,
                        attraction: attraction,
                        formPhase: formPhase
                    )
                    .stroke(Color.white.opacity(0.25), lineWidth: 1.0)
                )
                
                // ✨ Luz superior
                MoodBlobShape(
                    irregularity: spikeAmount,
                    attraction: attraction,
                    formPhase: formPhase
                )
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.35),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .padding(18)
                .blendMode(.screen)
                
            }
            .shadow(
                color: softGlowColor.opacity(0.18),
                radius: 20 + (breathe * 10),
                x: 0,
                y: 12 + (breathe * 4)
            )
            .scaleEffect((0.92 + (moodValue * 0.10)) + (breathe * 0.03))
            .offset(y: breathe * 2)
        }
    }
    
    // 🎨 NUEVA PALETA
    
    private var softTopColor: Color {
        Color(
            red: 232/255,  // #E8DBCC
            green: 219/255,
            blue: 204/255
        )
    }
    
    private var softMidColor: Color {
        Color(
            red: 234/255,  // #EAADCC
            green: 173/255,
            blue: 204/255
        )
    }
    
    private var softBottomColor: Color {
        Color(
            red: 95/255,   // #5F0C2F
            green: 12/255,
            blue: 47/255
        )
    }
    
    private var softGlowColor: Color {
        Color(
            red: 60/255,   // #3C0E18
            green: 14/255,
            blue: 24/255
        )
    }
}

struct MoodBlobShape: Shape {
    var irregularity: CGFloat   // 0 = suave, 1 = con muchos picos
    var attraction: CGFloat     // 0 = blob libre, 1 = más regular
    var formPhase: CGFloat      // 0...1 = transición entre formas regulares
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(irregularity, AnimatablePair(attraction, formPhase))
        }
        set {
            irregularity = newValue.first
            attraction = newValue.second.first
            formPhase = newValue.second.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let baseRadius = min(rect.width, rect.height) * 0.33
        let points = 220
        
        var path = Path()
        
        for i in 0...points {
            let angle = (CGFloat(i) / CGFloat(points)) * .pi * 2
            
            // Blob irregular con énfasis en estados malos
            let wave1 = sin(angle * 8)
            let wave2 = sin(angle * 55 + 0.9)
            let wave3 = sin(angle * 52 + 1.8)
            let wave4 = sin(angle * 30 + 0.4)
            
            let spikeStrength = 24 * irregularity
            let spike = spikeStrength * (
                0.34 * wave1 +
                0.56 * wave2 +
                0.22 * wave3 +
                0.58 * wave4
            )
            
            let blobRadius = baseRadius + spike
            
            // Formas regulares atractoras
            let circleRadius = baseRadius
            let hexRadius = baseRadius * (1 + 0.055 * cos(angle * 6))
            let roundedSquareRadius = baseRadius * (1 + 0.085 * cos(angle * 4))
            
            let regularRadius: CGFloat
            if formPhase < 0.5 {
                let localT = formPhase * 2
                regularRadius = mix(circleRadius, hexRadius, localT)
            } else {
                let localT = (formPhase - 0.5) * 2
                regularRadius = mix(hexRadius, roundedSquareRadius, localT)
            }
            
            let finalRadius = mix(blobRadius, regularRadius, min(max(attraction, 0), 1))
            
            let x = center.x + cos(angle) * finalRadius
            let y = center.y + sin(angle) * finalRadius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
    
    private func mix(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}
