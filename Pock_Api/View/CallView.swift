//
//  CallView.swift
//  Pock_Api
//
//  Created by Oliver Santos on 06/09/23.
//

import SwiftUI

struct CallView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    @State private var isChatView: Bool = false
    @State private var isParticipantView: Bool = false
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        HStack{
            Button(action: {
                webSocketManager.sendDesconected()
                dismiss()
            }){
                Image(systemName: "phone.down")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 30)
                    .background(.red)
                    .cornerRadius(10)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Meeting")
            }
            ToolbarItem(placement: .navigationBarTrailing){
                HStack {
                    Image(systemName: "message")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            isChatView.toggle()
                        }
                    Image(systemName: "person.2")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            isParticipantView.toggle()
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isChatView) {
            WebSocketFormView(webSocketManager: webSocketManager)
        }
        .navigationDestination(isPresented: $isParticipantView) {
            ParticipantsView(webSocketManager: webSocketManager)
        }
    }
}

struct CallView_Previews: PreviewProvider {
    static var previews: some View {
        CallView(webSocketManager: WebSocketManager())
    }
}
