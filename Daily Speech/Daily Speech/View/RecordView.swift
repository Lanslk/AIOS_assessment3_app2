//
//  RecordView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI

struct RecordView: View {
    
    @Binding public var topic: String
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            Text("Your Topic")
                .font(.title)
                .foregroundColor(.mint)
            Text(topic)
                .font(.title)
            Spacer()
            
            // Show recognized text in a Text view
            Text(speechRecognizer.recognizedText)
                .padding()
            
            // Record button to start and stop recording
            Button(action: {
                isRecording.toggle()
                if isRecording {
                    speechRecognizer.startRecording()
                } else {
                    speechRecognizer.stopRecording()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        
    }
}

#Preview {
    RecordView(topic: .constant("Introduce yourself"))
}
