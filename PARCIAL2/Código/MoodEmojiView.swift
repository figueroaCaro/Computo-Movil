//
//  MoodEmojiView.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//
import SwiftUI
struct MoodEmojiView: View {
    var moodValue: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor.opacity(0.18))
                .frame(width: 180, height: 180)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
                .shadow(color: backgroundColor.opacity(0.12), radius: 18, x: 0, y: 8)
            
            Text(currentEmoji)
                .font(.system(size: 95))
                .scaleEffect(0.92 + (moodValue * 0.14))
                .animation(.spring(response: 0.28, dampingFraction: 0.72), value: moodValue)
        }
    }
    
    var currentEmoji: String {
        switch moodValue {
        case 0.0..<0.2:
            return "😞"
        case 0.2..<0.4:
            return "😕"
        case 0.4..<0.6:
            return "😐"
        case 0.6..<0.8:
            return "🙂"
        default:
            return "😄"
        }
    }
    
    var backgroundColor: Color {
        switch moodValue {
        case 0.0..<0.2:
            return Color(red: 0.88, green: 0.72, blue: 0.76)
        case 0.2..<0.4:
            return Color(red: 0.92, green: 0.81, blue: 0.72)
        case 0.4..<0.6:
            return Color(red: 0.84, green: 0.84, blue: 0.88)
        case 0.6..<0.8:
            return Color(red: 0.75, green: 0.84, blue: 0.92)
        default:
            return Color(red: 0.76, green: 0.89, blue: 0.82)
        }
    }
}
