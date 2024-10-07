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
            
            // Video recording view, TODO not testable on simulator
//            VideoViewControllerRepresentable()
//                .frame(height: 300)
                        
            
            // Show recognized text in a Text view
            ScrollView {
               // TextEditor to show and edit the recognized text
               TextEditor(text: $speechRecognizer.recognizedText)
                   .padding()
                   .frame(minHeight: 100, maxHeight: 500)
                   .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
            Spacer()
            
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
