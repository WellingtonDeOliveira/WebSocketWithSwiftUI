//
//  Extension.swift
//  Pock_Api
//
//  Created by Oliver Santos on 12/09/23.
//
import SwiftUI
import Starscream

extension Array {
    func randomElement() -> Element? {
        if isEmpty { return nil }
        let randomIndex = Int.random(in: 0..<count)
        return self[randomIndex]
    }
}

extension WebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected:
            isConnected = true
            print("Connected")
            // Handshake completed, you can send the join request here.
        case .disconnected(let reason, _):
            isConnected = false
            print("Disconnected: \(reason)")
            
        case .text(let text):
            // Handle other incoming messages here
            print("Received message: \(text)")
            do {
                if let messageData = text.data(using: .utf8),
                   let receivedMessage = try JSONSerialization.jsonObject(with: messageData, options: []) as? [String: Any] {
                    let type = receivedMessage["type"] as! String
                    let kind = receivedMessage["kind"] as? String ?? ""
                    switch type {
                    case "handshake":
                        sendJoinRequest()
                    case "chat", "chathistory":
                        addMessageFromJSONString(jsonObject: receivedMessage)
                        
                    case "ping":
                        // Lógica para mensagens do tipo "ping"
                        sendPong()
                        
                    case "user":
                        if kind == "add" {
                            if let randomColor = colors.randomElement() {
                                // Use a cor aleatória, por exemplo, definindo-a como a cor de fundo de uma view
                                let selectedColor: Color = randomColor
                                print("Cor Selecionada: \(selectedColor)")
                                // Agora você pode usar selectedColor onde for necessário
                                addUser(jsonObject: receivedMessage, color: selectedColor)
                                
                            } else {
                                print("O array de cores está vazio.")
                            }
                        } else if kind == "delete" {
                            removeUser(jsonObject: receivedMessage)
                        }
                        
                    default:
                        break
                    }
                }
            } catch {
                print("Erro ao serializar JSON: \(error)")
            }
            
        default:
            break
        }
    }
}
