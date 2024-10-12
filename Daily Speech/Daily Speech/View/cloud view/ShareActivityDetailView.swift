//
//  SwiftUIView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 10/10/2024.
//

import SwiftUI
import SwiftData

struct ShareActivityDetailView: View {
    @State var activity: Activity
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Shared Speech")
                .foregroundColor(.mint)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            Text(activity.topic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Author: \(activity.account)")
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(activity.content)
                .frame(height: 200)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            if let recordingURL = activity.url {
                Text("Audio Record:")
                Button(action: {
                    if isPlaying {
                        speechRecognizer.stopPlaying()  // Stop playback if currently playing
                    } else {
                        speechRecognizer.playRecordingFromCloud(url: recordingURL)  // Play recording
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
        }
        .padding()
    }
}

#Preview {
    ShareActivityDetailView(activity: Activity(topic: "Sample Topic", content: "Sample Content", account:"test@gmail.com"))
}
