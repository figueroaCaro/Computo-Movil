//
//  MoodCheckingVIew.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//

import SwiftUI

struct MoodCheckInView: View {
    
    @State private var moodValue: Double = 0.5
    @State private var goToChat = false
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Spacer().frame(height: 20)
                
                Text("¿Cómo te sientes hoy?")
                    .font(.system(size: 34, weight: .light, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.85))
                
                Text(moodTitle)
                    .font(.title3.weight(.medium))
                    .animation(.easeInOut(duration: 0.2), value: moodValue)
                
                MorphingMoodOrb(moodValue: moodValue)
                    .frame(width: 220, height: 220)
                
                Text(moodDescription)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 18) {
                    Text("Selecciona cómo te sientes")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                    
                    MoodSlider(value: $moodValue)
                        .frame(height: 44)
                    
                    HStack {
                        Text("Muy mal")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("Muy bien")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(22)
                .background(.white.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                Button {
                    goToChat = true
                } label: {
                    Text("Continuar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.72, green: 0.66, blue: 0.95),
                                    Color(red: 0.58, green: 0.76, blue: 0.98)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
                .navigationDestination(isPresented: $goToChat) {
                    ChatView()
                }
            }
        }
    }
    
    var moodTitle: String {
        switch moodValue {
        case 0.0..<0.2:
            return "Muy mal"
        case 0.2..<0.4:
            return "Mal"
        case 0.4..<0.6:
            return "Neutral"
        case 0.6..<0.8:
            return "Bien"
        default:
            return "Muy bien"
        }
    }
    
    var moodDescription: String {
        switch moodValue {
        case 0.0..<0.2:
            return "Parece que estás pasando un momento pesado."
        case 0.2..<0.4:
            return "Hoy no te sientes del todo bien."
        case 0.4..<0.6:
            return "Te sientes más o menos estable."
        case 0.6..<0.8:
            return "Tu estado de ánimo va bastante bien."
        default:
            return "Te sientes muy bien en este momento."
        }
    }
    
    var moodColor: Color {
        switch moodValue {
        case 0.0..<0.2:
            return .red.opacity(0.75)
        case 0.2..<0.4:
            return .orange.opacity(0.85)
        case 0.4..<0.6:
            return .gray
        case 0.6..<0.8:
            return .blue.opacity(0.8)
        default:
            return .green.opacity(0.8)
        }
    }
}


#Preview {
    MoodCheckInView()
}
