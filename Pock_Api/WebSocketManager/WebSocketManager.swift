import SwiftUI
import Starscream

class WebSocketManager: ObservableObject {
    public var socket: WebSocket?
    @Published var isConnected: Bool = false
    @Published var group: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var messages: [Message] = []
    @Published var messagesTemp: [Message] = []
    @Published var users: [User] = []
    public var colors: [Color] = [.red, .blue, .purple, .yellow, .orange]
    
    func connected() {
        if !isConnected {
            let urlString = "wss://galene.org:8443/ws"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                socket = WebSocket(request: request)
                socket?.delegate = self
                socket?.connect()
            }
        }
    }
    
    func removeUser(jsonObject: [String: Any] ) {
        let username = jsonObject["username"] as! String
        users = users.filter { $0.username != username }
    }
    
    func addUser(jsonObject: [String: Any] , color: Color) {
        var selectedColor = color
        let idUser = jsonObject["id"] as! String
        let username = jsonObject["username"] as! String
        if username == self.username {
            selectedColor = .green
        }
        let user = User(id: idUser, username: username, colorMensagen: selectedColor)
        users.append(user)
        print("Novo Usuario: \(username)")
        for i in 0..<messagesTemp.count {
            let message = messagesTemp[i]
            if message.personName == "Eu" {
                messagesTemp[i].color = .green
            }
            if message.personName == username {
                // Essa mensagem pertence ao usuário atual, então definimos a cor
                messagesTemp[i].color = selectedColor
                print("MensagensCOlor: \(selectedColor)")
            }
        }
    }
    
    func addMessageFromJSONString(jsonObject: [String: Any]) {
        let idUser = jsonObject["source"] as! String
        let messageText = jsonObject["value"] as! String
        var username = jsonObject["username"] as! String
        let time = jsonObject["time"] as! String
        if username == self.username {
            username = "Eu"
        }
        let message = Message(idUser: idUser, text: messageText, personName: username, time: time)
        messagesTemp.append(message)
        print("Mensagem adicionada: \(messageText)")
    }
    
    func sendDesconected() {
        isConnected = false
        messagesTemp = []
        users = []
        socket?.disconnect()
    }
    
    func sendHandshake() {
        let jsonObject: [String: Any] = [
            "type": "handshake",
            "version": ["2"],
            "id": "b64846e5b3ef1acd83788adf3b470uf2"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print("My: \(jsonObject)")
            socket?.write(data: jsonData)
        } catch {
            print("Erro ao serializar JSON: \(error)")
        }
    }
    
    func sendChat(mss: String) {
        let jsonObject: [String: Any] = [
            "source": "b64846e5b3ef1acd83788adf3b470uf2",
            "type": "chat",
            "username": self.username,
            "value": mss
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print("My: \(jsonObject)")
            socket?.write(data: jsonData)
        } catch {
            print("Erro ao serializar JSON: \(error)")
        }
    }
    
    func sendPong() {
        let jsonObject: [String: Any] = [
            "type": "pong"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print("My: \(jsonObject)")
            socket?.write(data: jsonData)
        } catch {
            print("Erro ao serializar JSON: \(error)")
        }
    }
    
    func sendJoinRequest() {
        let jsonObject: [String: Any] = [
            "type": "join",
            "kind": "join",
            "group": group,
            "username": username
        ]
        
        do {
            let joinData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print("My: \(jsonObject)")
            socket?.write(data: joinData)
        } catch {
            print("Erro ao serializar JSON: \(error)")
        }
    }
}
