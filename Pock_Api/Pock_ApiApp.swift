//
//  Pock_ApiApp.swift
//  Pock_Api
//
//  Created by Oliver Santos on 22/08/23.
//

import SwiftUI

@main
struct ChatApp: App {
    @ObservedObject var webSocketManager = WebSocketManager()
    var body: some Scene {
        WindowGroup {
//            ContentView()
            LoginView(webSocketManager: webSocketManager)
        }
    }
}
