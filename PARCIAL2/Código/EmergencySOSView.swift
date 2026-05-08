//
//  EmergencyView.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//

import SwiftUI

struct EmergencySOSView: View {
    let phrase: String
    let emergencyNumber: String
    let contactName: String
    let contactPhone: String
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.94, blue: 0.95),
                    Color(red: 0.95, green: 0.96, blue: 0.99)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 22) {
                Spacer()
                
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 62))
                    .foregroundColor(.red.opacity(0.85))
                
                Text("Apoyo inmediato")
                    .font(.system(size: 34, weight: .light, design: .serif))
                    .foregroundColor(.black.opacity(0.85))
                
                Text(phrase)
                    .font(.system(size: 19, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.78))
                    .padding(.horizontal, 28)
                
                Text("Busca apoyo ahora. Puedes llamar a emergencias o a tu contacto de confianza.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 28)
                
                VStack(spacing: 14) {
                    Button {
                        if let url = URL(string: "tel://\(emergencyNumber)") {
                            openURL(url)
                        }
                    } label: {
                        Text("Llamar a emergencias")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.red.opacity(0.88))
                            .clipShape(Capsule())
                    }
                    
                    if !contactPhone.isEmpty {
                        Button {
                            if let url = URL(string: "tel://\(contactPhone)") {
                                openURL(url)
                            }
                        } label: {
                            Text("Llamar a \(contactName)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.blue.opacity(0.82))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button("Cerrar") {
                    dismiss()
                }
                .foregroundColor(.gray)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    EmergencySOSView(
        phrase: "Este momento puede cambiar. No tienes que cargarlo solo.",
        emergencyNumber: "911",
        contactName: "Contacto de confianza",
        contactPhone: "5555555555"
    )
}
