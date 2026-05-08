import SwiftUI

struct ChatView: View {
    
    @StateObject private var vm = ChatViewModel()
    @State private var isChatOpen = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.98)
                .ignoresSafeArea()
            
            if isChatOpen {
                chatScreen
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                homeScreen
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isChatOpen)
        .fullScreenCover(isPresented: $vm.showEmergencySOS) {
            EmergencySOSView(
                phrase: vm.emergencyPhrase,
                emergencyNumber: vm.localEmergencyNumber,
                contactName: vm.emergencyContactName,
                contactPhone: vm.emergencyContactPhone
            )
        }
    }
    
    private var homeScreen: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Lumi")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Capsule())
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            
            Spacer()
            
            VStack(spacing: 22) {
                GradientBubble()
                    .scaleEffect(0.75)
                    .frame(height: 140)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("¡Hola!")
                        .font(.system(size: 26, weight: .light, design: .serif))
                        .foregroundColor(Color(red: 0.55, green: 0.49, blue: 0.75))
                    
                    Text("¿Cómo puedo ayudarte hoy?")
                        .font(.system(size: 36, weight: .light, design: .serif))
                        .foregroundColor(.black.opacity(0.85))
                    
                    Text("Recuerda que este es un espacio seguro donde puedes desahogarte y pedir ayuda si lo necesitas.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 6)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
            }
            
            Spacer()
            
            bottomInputBar
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
    }
    
    private var chatScreen: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation {
                        isChatOpen = false
                        isInputFocused = false
                    }
                } label: {
                    Text("Nuevo chat")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            
            Spacer(minLength: 10)
            
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(vm.messages) { msg in
                            HStack {
                                if msg.isUser { Spacer() }
                                
                                Text(msg.text)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        msg.isUser
                                        ? Color(red: 0.86, green: 0.82, blue: 0.96)
                                        : Color.white.opacity(0.9)
                                    )
                                    .foregroundColor(.black.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .frame(maxWidth: 280, alignment: msg.isUser ? .trailing : .leading)
                                
                                if !msg.isUser { Spacer() }
                            }
                            .id(msg.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
                .onChange(of: vm.messages.count) { _ in
                    if let last = vm.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            bottomInputBar
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
    }
    
    private var bottomInputBar: some View {
        HStack(spacing: 10) {
            if isChatOpen {
                GradientBubble()
                    .scaleEffect(0.16)
                    .frame(width: 34, height: 34)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
            
            TextField("Escribe aquí...", text: $vm.messageText)
                .foregroundColor(.black)
                .focused($isInputFocused)
                .padding(.horizontal, 18)
                .frame(height: 56)
                .background(Color.white.opacity(0.92))
                .clipShape(Capsule())
                .onSubmit {
                    handleSend()
                }
            
            Button(action: handleSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
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
                    .clipShape(Circle())
            }
            .disabled(vm.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(vm.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1)
        }
    }
    
    private func handleSend() {
        let isFirstMessage = vm.messages.isEmpty
        
        vm.sendMessage()
        
        if isFirstMessage {
            withAnimation(.easeInOut(duration: 0.35)) {
                isChatOpen = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isInputFocused = true
            }
        }
    }
}

#Preview {
    ChatView()
}
