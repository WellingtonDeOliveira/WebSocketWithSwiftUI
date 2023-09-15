//
//  CameraView.swift
//  Pock_Api
//
//  Created by Oliver Santos on 13/09/23.
//

import SwiftUI
import AVFoundation

struct AudioView: View {
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            if isRecording {
                Text("Gravando...")
                Button("Parar Gravação") {
                    stopRecording()
                }
            } else {
                Button("Iniciar Gravação") {
                    startRecording()
                }
                Button("Reproduzir Gravação") {
                    playRecording()
                }
            }
        }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let audioSettings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let audioURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: audioSettings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            // Handle error
            print("Erro ao iniciar a gravação: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    func playRecording() {
        let audioURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch {
            // Handle error
            print("Erro ao reproduzir a gravação: \(error.localizedDescription)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let documentsPath = documentsDirectory.path // Obtém o caminho como uma string
        print("Caminho do diretório de documentos: \(documentsPath)") // Imprime o caminho
        return documentsDirectory
    }
}

class AudioManager : ObservableObject {
    @Published var permissionGranted = false
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                self.permissionGranted = accessGranted
            }
        })
    }
}
