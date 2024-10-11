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
import FirebaseStorage

class SpeechRecognizer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    @Published var recognizedText = ""
    private var previousSegmentText = "" // To track only the last segment
    
    // Recording-related properties
    private var audioRecorder: AVAudioRecorder?
    public var audioPlayer: AVAudioPlayer?
    let audioSession = AVAudioSession.sharedInstance()
    
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
    
    // Start audio recording
    func startAudioRecording() -> URL {
        let fileName = UUID().uuidString + ".m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        print(filePath)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder?.record()
        } catch {
            print("Could not start audio recording: \(error)")
        }
        return filePath
    }
    
    // Stop audio recording
    func stopAudioRecording() {
        audioRecorder?.stop()
    }
    
    // Play a selected recording from local
    func playRecording(url: URL) {
        print("Trying to play audio at URL: \(url)")
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print("Could not play audio: \(error)")
            }
        } else {
            print("Audio file not found at \(url.path)")
        }
    }
    
    // Play a selected recording from cloud
    func playRecordingFromCloud(url: URL) {
        print("Trying to play audio at URL: \(url)")
        
        let firebaseFilePath = "audio/\(url.lastPathComponent)"
        
        downloadAudioFromFirebase(audioRefPath: firebaseFilePath) { result in
            switch result {
            case .success(let fileURL):
                print("Audio downloaded successfully: \(fileURL)")
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // Configure audio session
                        try? self.audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
                        try? self.audioSession.setActive(true)
                        
                        self.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                        self.audioPlayer?.delegate = self
                        self.audioPlayer?.play()
                    } catch {
                        print("Could not play audio: \(error)")
                    }
                } else {
                    print("Audio file not found at \(fileURL.path)")
                }
            case .failure(let error):
                print("Failed to download audio: \(error)")
            }
        }
    }
    
    // Stop playing
    func stopPlaying() {
        audioPlayer?.stop()
    }
    
    // AVAudioPlayerDelegate method that triggers when playback finishes
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Notify when the playback finishes
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // download audio from firebase cloud
    func downloadAudioFromFirebase(audioRefPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        // Create a storage reference
        let storageRef = Storage.storage().reference()
        let audioRef = storageRef.child(audioRefPath)
        
        // Create a temporary URL to save the downloaded audio file
        let temporaryDir = FileManager.default.temporaryDirectory
        let localURL = temporaryDir.appendingPathComponent(UUID().uuidString + ".m4a")
        
        // Download the file
        audioRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("Error downloading file: \(error)")
                completion(.failure(error))
            } else {
                print("File downloaded successfully: \(localURL)")
                completion(.success(localURL))
            }
        }
    }
    
    // Helper function to get documents directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
