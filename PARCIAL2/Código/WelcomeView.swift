import SwiftUI


struct WelcomeView: View {
    @State private var animateLumi = false
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.93, blue: 0.99),
                    Color(red: 0.90, green: 0.95, blue: 1.00)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                
                Spacer()
                
                Text("Lumi")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.56, green: 0.46, blue: 0.92),
                                Color(red: 0.44, green: 0.68, blue: 0.98)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(animateLumi ? 1.03 : 0.97)
                    .opacity(animateLumi ? 1.0 : 0.92)
                    .shadow(
                        color: Color(red: 0.56, green: 0.46, blue: 0.92).opacity(animateLumi ? 0.22 : 0.10),
                        radius: animateLumi ? 12 : 6,
                        x: 0,
                        y: 4
                    )
                    .padding(.bottom, 42)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                            animateLumi = true
                        }
                    }
                
                GradientBubble()
                    .scaleEffect(0.75)
                    .frame(height: 140)
                    .padding(.bottom, 40)

                VStack(spacing: 12) {
                    Text("Tu espacio emocional")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    
                    Text("Habla, escribe y mejora tu bienestar con ayuda de inteligencia artificial.")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 24)
                }
                
                Spacer()
                
                NavigationLink(destination: MoodCheckInView()) {
                    Text("Comenzar")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.67, green: 0.56, blue: 0.95),
                                    Color(red: 0.54, green: 0.72, blue: 0.98)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                }
                .padding(.horizontal)
                
                Button("Aún no tengo cuenta") {
                    // acción futura login
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                
                Spacer().frame(height: 12)
            }
            .padding()
        }
    }
}
