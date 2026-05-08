//
//  ChatModels.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//

import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

enum DetectedEmotion {
    case anxiety
    case stress
    case sadness
    case anger
    case loneliness
    case overwhelm
    case emergency
    case neutral
}
