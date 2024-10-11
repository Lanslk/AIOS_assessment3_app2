//
//  ReviseView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI
import SwiftData

struct ReviseView: View {
    @Environment(\.modelContext) private var context  // Get context from the environment
    
    @EnvironmentObject var userAccount: UserAccount
    
    @Binding public var topic: String
    @Binding public var origin: String
    @Binding public var content: String
    @Binding public var url: URL?
    
    @State private var showAlert = false
    @State private var navigateToSavedView = false
    @StateObject private var speechRecognizer = SpeechRecognizer()  // Create an instance of SpeechRecognizer

    @State private var isPlaying = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Revise your speech")
                    .font(.title)
                    .foregroundColor(.mint)
                
                Spacer()
                
                Text("Topic: \(topic)")
                
                Spacer()
                
                if let recordingURL = url {
                    Text("Audio Record")
                    Button(action: {
                        if isPlaying {
                            speechRecognizer.stopPlaying()  // Stop playback if currently playing
                        } else {
                            speechRecognizer.playRecording(url: recordingURL)  // Play recording
                        }
                        isPlaying.toggle()  // Toggle the play state
                    }) {
                        Text(isPlaying ? "Stop" : "Play")
                            .padding()
                            .background(isPlaying ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .onReceive(speechRecognizer.objectWillChange) {
                        if speechRecognizer.audioPlayer?.isPlaying == false {
                            isPlaying = false  // Reset play state when playback
                        }
                    }
                } else {
                    Text("No recording available.")
                }
                
                ScrollView {
                    Text("Original")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.blue)
                    
                    TextEditor(text: $origin)
                        .padding()
                        .frame(minHeight: 200, maxHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                
                ScrollView {
                    Text("Revised")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.green)
                    
                    TextEditor(text: $content)
                        .padding()
                        .frame(minHeight: 200, maxHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                
                Button(action: {
                    if content.isEmpty {
                        showAlert = true  // Show alert if topic is empty
                    } else {
                        // navigate to RecordView
                        saveActivity(topic: topic, content: content, account: userAccount.email, context: context, url: url)
                        navigateToSavedView = true
                    }
                }, label: {
                    Text("Save")
                        .font(.title)
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Content Required"),
                        message: Text("Revised content is blank."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationDestination(isPresented: $navigateToSavedView) {
                    SavedView()
                        .environmentObject(userAccount)
                }
                
            }
            .padding()
            
        }
    }
}

#Preview {
    ReviseView(
            topic: .constant("Introduce yourself"),
            origin: .constant("Introducing yourself"),
            content: .constant("Introduce yourself"),
            url: .constant(URL.applicationDirectory)
        )
        .modelContainer(for: Activity.self)
}
