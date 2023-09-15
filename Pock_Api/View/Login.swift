//
//  Login.swift
//  Pock_Api
//
//  Created by Oliver Santos on 05/09/23.
//

import SwiftUI

struct LoginView: View {
    @State private var showAlert = false
    @State private var isConected = false
    @ObservedObject private var webSocketManager: WebSocketManager
    
    init(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
        webSocketManager.connected()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Username", text: $webSocketManager.username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Group", text: $webSocketManager.group)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // Faça a conexão com o WebSocket aqui
                    if !webSocketManager.username.isEmpty && !webSocketManager.group.isEmpty {
                        webSocketManager.sendHandshake()
                        isConected = true
                    } else {
                        showAlert = true // Exibir um alerta de erro
                    }
                }) {
                    Text("Conectar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationBarTitle("Login")
            .navigationDestination(isPresented: $isConected) {
                CallView(webSocketManager: webSocketManager)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Erro"), message: Text("Não foi possível fazer a conexão com o WebSocket"), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(webSocketManager: WebSocketManager())
    }
}
