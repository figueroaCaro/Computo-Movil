//
//  EmotionDetector.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//

import Foundation

enum EmotionDetector {
    
    static func detectEmotion(in text: String) -> DetectedEmotion {
        let normalized = normalize(text)
        
        let emergencyKeywords = [
            "me quiero morir", "quiero morir", "matarme", "quitarme la vida",
            "hacerme dano", "hacerme daño", "lastimarme", "cortarme",
            "no quiero vivir", "estoy en peligro"
        ]
        
        let anxietyKeywords = [
            "ansiedad", "ansioso", "ansiosa", "nervioso", "nerviosa",
            "panico", "pánico", "me cuesta respirar", "inquieto", "inquieta"
        ]
        
        let stressKeywords = [
            "estres", "estrés", "presion", "presión", "tension", "tensión",
            "saturado", "saturada", "mucho trabajo", "no puedo con todo"
        ]
        
        let sadnessKeywords = [
            "triste", "llorar", "vacío", "vacio", "sin ganas",
            "desanimado", "desanimada", "me siento mal"
        ]
        
        let angerKeywords = [
            "enojado", "enojada", "furioso", "furiosa", "molesto",
            "molesta", "frustrado", "frustrada", "rabia", "coraje"
        ]
        
        let lonelinessKeywords = [
            "solo", "sola", "aislado", "aislada", "nadie me entiende",
            "sin apoyo", "me siento solo", "me siento sola"
        ]
        
        let overwhelmKeywords = [
            "abrumado", "abrumada", "agobiado", "agobiada",
            "no se que hacer", "no sé qué hacer", "todo me supera", "colapsando"
        ]
        
        if emergencyKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .emergency
        }
        if anxietyKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .anxiety
        }
        if stressKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .stress
        }
        if sadnessKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .sadness
        }
        if angerKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .anger
        }
        if lonelinessKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .loneliness
        }
        if overwhelmKeywords.contains(where: { normalized.contains(normalize($0)) }) {
            return .overwhelm
        }
        
        return .neutral
    }
    
    static func response(for emotion: DetectedEmotion) -> String {
        switch emotion {
        case .anxiety:
            return "Parece que estás sintiendo ansiedad. Intenta esto: respira 4 segundos, sostén 4 y exhala 6, cinco veces. Luego mira a tu alrededor y nombra 5 cosas que ves."
        case .stress:
            return "Detecto estrés. Te puede ayudar pausar 2 minutos, soltar hombros y escribir solo 3 cosas prioritarias para resolver hoy."
        case .sadness:
            return "Parece que te sientes triste. Intenta una acción pequeña de cuidado: tomar agua, sentarte en un lugar tranquilo o escribir lo que sientes en una frase."
        case .anger:
            return "Detecto enojo o frustración. Haz una pausa antes de responder, respira profundo y aléjate un momento del estímulo para bajar la intensidad."
        case .loneliness:
            return "Parece que te sientes solo o sin apoyo. Una opción útil es enviar un mensaje corto a alguien de confianza y pedirle hablar unos minutos."
        case .overwhelm:
            return "Detecto agobio. Vamos paso a paso: elige una sola tarea pequeña, hazla durante 5 minutos y luego vuelve a evaluar cómo te sientes."
        case .emergency:
            return "Detecto señales de riesgo. Busca apoyo inmediato de una persona de confianza, un profesional o un servicio de emergencias en tu zona. No te quedes solo."
        case .neutral:
            return "Estoy aquí contigo. Cuéntame un poco más para entender mejor cómo te sientes y ayudarte de una forma más precisa."
        }
    }
    
    private static func normalize(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
