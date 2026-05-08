//
//  MoodSlider.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//
import SwiftUI
struct MoodSlider: View {
    @Binding var value: Double   // 0.0 a 1.0
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let knobSize: CGFloat = 30
            let xPosition = max(knobSize / 2, min((width - knobSize / 2), value * (width - knobSize) + knobSize / 2))
            
            ZStack(alignment: .leading) {
                
                Capsule()
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 14)
                
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.96, green: 0.55, blue: 0.62),
                                Color(red: 0.98, green: 0.76, blue: 0.45),
                                Color(red: 0.70, green: 0.84, blue: 0.62)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: xPosition, height: 14)
                
                Circle()
                    .fill(.white)
                    .frame(width: knobSize, height: knobSize)
                    .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .position(x: xPosition, y: 22)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let newX = min(max(gesture.location.x, knobSize / 2), width - knobSize / 2)
                                value = (newX - knobSize / 2) / (width - knobSize)
                            }
                    )
            }
        }
    }
}
