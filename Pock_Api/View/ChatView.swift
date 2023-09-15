//
//  ConnectionFormView.swift
//  Pock_Api
//
//  Created by Oliver Santos on 30/08/23.
//

import SwiftUI

struct WebSocketFormView: View {
    
    @State private var myMens: String = ""
    @ObservedObject var webSocketManager: WebSocketManager
    
    var body: some View {
        VStack {
            MessageListView(messages: $webSocketManager.messagesTemp)
            TextField("Chat", text: $myMens)
                .padding()
            
            Button("Enviar") {
                webSocketManager.sendChat(mss: myMens)
                myMens = ""
            }
            .padding()
            
            if webSocketManager.isConnected {
                Text("Conectado")
                    .foregroundColor(.green)
            } else {
                Text("Não Conectado")
                    .foregroundColor(.red)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Chat (\(webSocketManager.users.count))")
            }
        }
    }
}

//struct ConnectionFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebSocketFormView(webSocketManager: webSocketManager)
//    }
//}
