//
//  SpeechRecognizer.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftUI
import Speech
import AVFoundation

class SpeechRecognizer: ObservableObject {
    private var speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    @Published var recognizedText = ""
    private var previousSegmentText = "" // To track only the last segment
    
    func startRecording() {
        // Check if there's an active task, and cancel it before starting a new one
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Stop the audio engine if it's already running
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Initialize recognition request and task
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                // Get the current transcription
                let currentText = result.bestTranscription.formattedString
                
                // Extract only the new segment that hasn't been appended yet
                let newSegment = self.getNewSegment(currentText)
                
                // Append only the new segment
                if !newSegment.isEmpty {
                    self.recognizedText += newSegment + " "
                }
                
                // Update the last segment text
                self.previousSegmentText = currentText
            }
            if error != nil || result?.isFinal == true {
                // Stop recognition if there is an error or result is final
                self.stopRecording()
            }
        }
        
        // Set up microphone input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Remove any existing tap before setting a new one
        inputNode.removeTap(onBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            recognitionRequest.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    // Helper function to get the new segment
    private func getNewSegment(_ currentText: String) -> String {
        // If the current text is longer than the previous, return the new part only
        if currentText.count > previousSegmentText.count {
            let startIndex = currentText.index(currentText.startIndex, offsetBy: previousSegmentText.count)
            return String(currentText[startIndex...])
        }
        return ""
    }
}
