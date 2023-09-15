//
//  ContentView.swift
//  Pock_Api
//
//  Created by Oliver Santos on 22/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var audioManager = AudioManager()
    
    var body: some View {
        VStack {
            if audioManager.permissionGranted {
                AudioView()
            }
        }
        .onAppear {
            audioManager.requestPermission()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
