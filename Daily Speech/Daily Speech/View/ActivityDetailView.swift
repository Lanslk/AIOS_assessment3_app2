//
//  SwiftUIView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 10/10/2024.
//

import SwiftUI
import SwiftData

struct ActivityDetailView: View {
    @Environment(\.modelContext) private var context
    @State var activity: Activity
    @State private var updatedTopic: String
    @State private var updatedContent: String
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = false
    
    init(activity: Activity) {
        _activity = State(initialValue: activity)
        _updatedTopic = State(initialValue: activity.topic)
        _updatedContent = State(initialValue: activity.content)
    }
    
    var body: some View {
        VStack {
            Text("Edit Speech")
                .foregroundColor(.mint)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            TextField("Topic", text: $updatedTopic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $updatedContent)
                .frame(height: 200)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            Spacer()
            
            if let recordingURL = activity.url {
                Text("Audio Record:")
                Button(action: {
                    if isPlaying {
                        speechRecognizer.stopPlaying()  // Stop playback if currently playing
                    } else {
                        print(recordingURL)
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
            
            Spacer()
            
            HStack {
                Button("Save") {
                    updateActivity(activity: activity, newTopic: updatedTopic, newContent: updatedContent, context: context)
                    dismiss()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                
                Button("Delete") {
                    deleteActivity(activity: activity, context: context)
                    dismiss()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ActivityDetailView(activity: Activity(topic: "Sample Topic", content: "Sample Content"))
}
