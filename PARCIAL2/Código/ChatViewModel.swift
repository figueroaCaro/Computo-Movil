//
//  ChatViewModel.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//

import SwiftUI
import Combine

final class ChatViewModel: ObservableObject {
    @Published var messageText = ""
    @Published var messages: [ChatMessage] = []
    
    @Published var showEmergencySOS = false
    @Published var emergencyPhrase = "Este momento puede cambiar. No tienes que cargarlo solo."
    
    // Cambia estos valores por los reales
    @Published var localEmergencyNumber = "911"
    @Published var emergencyContactName = "Contacto de confianza"
    @Published var emergencyContactPhone = "5555555555"
    
    private enum ConversationStep {
        case idle
        case waitingForSupportAnswer
        case waitingForScale
        case waitingForChoice
    }
    
    private var step: ConversationStep = .idle
    private var detectedEmotion: DetectedEmotion = .neutral
    private var hasSupport: Bool? = nil
    private var emotionalScale: Int? = nil
    
    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messages.append(ChatMessage(text: trimmed, isUser: true))
        messageText = ""
        
        // Riesgo en cualquier punto
        if isCrisisMessage(trimmed) {
            triggerEmergencyFlow()
            return
        }
        
        switch step {
        case .idle:
            handleInitialMessage(trimmed)
            
        case .waitingForSupportAnswer:
            handleSupportAnswer(trimmed)
            
        case .waitingForScale:
            handleScaleAnswer(trimmed)
            
        case .waitingForChoice:
            handleChoiceAnswer(trimmed)
        }
    }
    
    // MARK: - Paso 1
    private func handleInitialMessage(_ text: String) {
        detectedEmotion = EmotionDetector.detectEmotion(in: text)
        hasSupport = nil
        emotionalScale = nil
        
        let firstPrompt = firstQuestion(for: detectedEmotion)
        botReply(firstPrompt)
        step = .waitingForSupportAnswer
    }
    
    // MARK: - Paso 2
    private func handleSupportAnswer(_ text: String) {
        hasSupport = detectSupportAnswer(from: text)
        
        botReply("Te entiendo y estoy contigo. ¿Del 1 al 10, cómo te sientes en este momento?")
        step = .waitingForScale
    }
    
    // MARK: - Paso 3
    private func handleScaleAnswer(_ text: String) {
        guard let scale = extractScale(from: text) else {
            botReply("No pude identificar un número del 1 al 10. ¿Me lo puedes escribir así, por ejemplo: 4 o 7?")
            return
        }
        
        emotionalScale = scale
        
        if scale <= 2 {
            triggerEmergencyFlow()
            return
        }
        
        botReply(choiceQuestion(for: detectedEmotion))
        step = .waitingForChoice
    }
    
    // MARK: - Paso 4
    private func handleChoiceAnswer(_ text: String) {
        let intro = "Te puedo dar algunas soluciones que podrían ayudarte ahorita."
        let solution = buildSolution(
            emotion: detectedEmotion,
            scale: emotionalScale ?? 5,
            hasSupport: hasSupport
        )
        
        botReply(intro)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            self.botReply(solution)
            self.step = .idle
        }
    }
    
    // MARK: - Preguntas secuenciales
    private func firstQuestion(for emotion: DetectedEmotion) -> String {
        switch emotion {
        case .anxiety:
            return "Parece que lo que estás sintiendo se parece a ansiedad o inquietud. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .stress:
            return "Lo que me dices suena a mucho estrés o presión acumulada. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .sadness:
            return "Parece que estás pasando por un momento de tristeza o desánimo. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .anger:
            return "Detecto enojo, frustración o mucha tensión emocional. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .loneliness:
            return "Suena a que te sientes solo o con poco apoyo emocional. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .overwhelm:
            return "Parece que te estás sintiendo muy abrumado o agobiado. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .emergency:
            return "Detecto señales delicadas y quiero tomarlo con seriedad. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        case .neutral:
            return "Gracias por contármelo. ¿Tienes a alguien de confianza contigo o con quien puedas hablar ahorita?"
        }
    }
    
    private func choiceQuestion(for emotion: DetectedEmotion) -> String {
        switch emotion {
        case .anxiety:
            return "Gracias por decirme. ¿Quieres contarme qué pasa o quieres que te ayude con una técnica para la ansiedad?"
        case .stress:
            return "¿Quieres contarme qué está pasando o quieres que te ayude con una técnica para el estrés?"
        case .sadness:
            return "¿Quieres contarme qué pasa o quieres que te ayude con una técnica para sentirte un poco más estable?"
        case .anger:
            return "¿Quieres contarme qué pasó o quieres que te ayude con una técnica para bajar la intensidad?"
        case .loneliness:
            return "¿Quieres contarme qué pasa o quieres que te ayude con una técnica para sentir más apoyo emocional?"
        case .overwhelm:
            return "¿Quieres contarme qué está pasando o quieres que te ayude con una técnica para bajar el agobio?"
        case .emergency:
            return "¿Quieres contarme brevemente qué pasa o prefieres que te dé apoyo inmediato?"
        case .neutral:
            return "¿Quieres contarme un poco más o prefieres que te dé una técnica sencilla para ayudarte ahorita?"
        }
    }
    
    // MARK: - Detección de riesgo
    private func isCrisisMessage(_ text: String) -> Bool {
        let normalized = normalize(text)
        
        let crisisKeywords = [
            "morir",
            "me quiero morir",
            "quiero morir",
            "matarme",
            "quitarme la vida",
            "suicidio",
            "suicidarme",
            "ya no puedo mas",
            "ya no puedo más",
            "no puedo mas",
            "no puedo más",
            "quiero desaparecer",
            "hacerme dano",
            "hacerme daño",
            "lastimarme",
            "cortarme",
            "no quiero vivir",
            "estoy en peligro",
            "todo se acabo",
            "todo se acabó"
        ]
        
        return crisisKeywords.contains(where: { normalized.contains(normalize($0)) })
    }
    
    private func triggerEmergencyFlow() {
        step = .idle
        
        let optimisticPhrases = [
            "Este momento puede cambiar. No tienes que cargarlo solo.",
            "Aunque ahora se sienta muy pesado, esto puede mejorar con ayuda.",
            "Tu vida importa y pedir apoyo ahora es un paso muy valioso.",
            "No estás solo en esto. Hay apoyo posible para ti en este momento."
        ]
        
        emergencyPhrase = optimisticPhrases.randomElement()
            ?? "Este momento puede cambiar. No tienes que cargarlo solo."
        
        botReply("Detecto que podrías estar en una situación de riesgo. Voy a abrir apoyo inmediato.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.showEmergencySOS = true
        }
    }
    
    // MARK: - Soluciones
    private func buildSolution(emotion: DetectedEmotion, scale: Int, hasSupport: Bool?) -> String {
        switch emotion {
        case .anxiety:
            return "Okay, primero vamos a intentar regular tu respiración: inhala 4 segundos, sostén 4 y exhala 6. Repite esto cinco veces. Después mira a tu alrededor y nombra 5 cosas que ves para volver al presente. Intentalo y cuentame como te vas sintiendo."
            
        case .stress:
            return "Primero haz una pausa de 2 minutos. Suelta hombros y mandíbula, y escribe solamente 3 pendientes importantes. No intentes resolver todo al mismo tiempo."
            
        case .sadness:
            return "Empieza con algo pequeño y concreto: toma agua, cambia de lugar y escribe en una frase cómo te sientes. A veces ponerle nombre ayuda a bajar un poco la carga."
            
        case .anger:
            return "Haz una pausa antes de reaccionar. Aléjate un momento del estímulo, respira profundo y libera tensión física en manos, hombros y mandíbula."
            
        case .loneliness:
            return "Intenta contactar a una persona con un mensaje simple, aunque sea corto. Algo como: '¿puedes hablar conmigo unos minutos?' puede abrir apoyo real."
            
        case .overwhelm:
            return "Cuando todo se siente demasiado, reduce el enfoque. Elige una sola cosa para hacer durante 5 minutos y deja lo demás en pausa."
            
        case .neutral:
            return "Podemos empezar con una técnica simple: respira lento, relaja el cuerpo y dime qué parte de tu día te está pesando más."
            
        case .emergency:
            return "Lo más importante ahora es que no te quedes solo con esto y busques apoyo inmediato."
        }
    }
    
    // MARK: - Utilidades
    private func botReply(_ text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.messages.append(ChatMessage(text: text, isUser: false))
        }
    }
    
    private func detectSupportAnswer(from text: String) -> Bool? {
        let normalized = normalize(text)
        
        let yesWords = [
            "si", "sí", "tengo a alguien", "si tengo", "sí tengo",
            "mi mama", "mi mamá", "mi amigo", "mi amiga", "mi familia", "mi pareja"
        ]
        
        let noWords = [
            "no", "nadie", "no tengo a nadie", "estoy solo", "estoy sola",
            "no tengo", "ninguno", "ninguna"
        ]
        
        if yesWords.contains(where: { normalized.contains(normalize($0)) }) {
            return true
        }
        
        if noWords.contains(where: { normalized.contains(normalize($0)) }) {
            return false
        }
        
        return nil
    }
    
    private func extractScale(from text: String) -> Int? {
        let normalized = normalize(text)
        
        let wordsToNumbers: [String: Int] = [
            "uno": 1, "dos": 2, "tres": 3, "cuatro": 4, "cinco": 5,
            "seis": 6, "siete": 7, "ocho": 8, "nueve": 9, "diez": 10
        ]
        
        if let directNumber = Int(normalized), (1...10).contains(directNumber) {
            return directNumber
        }
        
        for (word, number) in wordsToNumbers {
            if normalized.contains(word) {
                return number
            }
        }
        
        let digits = normalized.compactMap { $0.wholeNumberValue }
        if let first = digits.first, (1...10).contains(first) {
            return first
        }
        
        return nil
    }
    
    private func normalize(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
