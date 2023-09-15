//
//  ParticipantsView.swift
//  Pock_Api
//
//  Created by Oliver Santos on 06/09/23.
//

import SwiftUI

struct ParticipantsView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    var body: some View {
        VStack{
            ParticipantListView(users: $webSocketManager.users)
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Participantes")
            }
        }
    }
}

struct ParticipantsView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsView(webSocketManager: WebSocketManager())
    }
}
