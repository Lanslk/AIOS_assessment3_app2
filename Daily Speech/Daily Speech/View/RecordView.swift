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
    
    @State private var showAlert = false
    @State private var showAlertAPI = false
    @State private var navigateToReviseView = false
    
    @State private var revisedContent = ""
    @State private var url: URL? = nil
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    Text("Your Speech")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.mint)
                    
                    TextEditor(text: $speechRecognizer.recognizedText)
                        .padding()
                        .frame(minHeight: 100, maxHeight: 500)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                .padding()
                Spacer()
                
                // Record button to start and stop recording
                Button(action: {
                    isRecording.toggle()
                    if isRecording {
                        speechRecognizer.startRecording()
                        url = speechRecognizer.startAudioRecording()
                    } else {
                        speechRecognizer.stopRecording()
                        speechRecognizer.stopAudioRecording()
                    }
                }) {
                    Image(systemName: "mic")
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                Button(action: {
                    if speechRecognizer.recognizedText.isEmpty {
                        showAlert = true  // Show alert if content is empty
                    } else {
                        sendChatGPTRequest(message: "Please correct the grammar: " + speechRecognizer.recognizedText) { response in
                            DispatchQueue.main.async {
                                if let response = response {
                                    revisedContent = response
                                    navigateToReviseView = true
                                } else {
                                    showAlertAPI = true
                                }
                            }
                        }
                        
                    }
                }, label: {
                    Text("Revised by AI")
                        .font(.title)
                })
                .alert(isPresented: Binding<Bool>(
                    get: { showAlert || showAlertAPI },
                    set: { _ in
                        showAlert = false
                        showAlertAPI = false
                    }
                )) {
                    if showAlert {
                        return Alert(
                            title: Text("Content Required"),
                            message: Text("Please enter your topic."),
                            dismissButton: .default(Text("OK"))
                        )
                    } else {
                        return Alert(
                            title: Text("Open AI response"),
                            message: Text("No response received."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToReviseView) {
                ReviseView(topic: $topic, origin: $speechRecognizer.recognizedText,content: $revisedContent, url: $url)
            }
        }
        
    }
}

#Preview {
    RecordView(topic: .constant("Introduce yourself"))
}
