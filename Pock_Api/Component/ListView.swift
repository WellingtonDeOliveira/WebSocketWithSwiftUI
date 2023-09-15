//
//  ListView.swift
//  Pock_Api
//
//  Created by Oliver Santos on 06/09/23.
//

import SwiftUI

struct MessageListView: View {
    @Binding var messages: [Message]
    
    var body: some View {
        List {
            ForEach(messages, id: \.self) { message in
                HStack{
                    Text("\(message.personName): ")
                        .foregroundColor(
                            message.color)
                    Text(message.text)
                }
            }
        }
    }
}

struct ParticipantListView: View {
    @Binding var users: [User]
    
    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                HStack{
                    Text("\(user.username)")
                        .foregroundColor(
                            user.colorMensagen)
                }
            }
        }
    }
}
