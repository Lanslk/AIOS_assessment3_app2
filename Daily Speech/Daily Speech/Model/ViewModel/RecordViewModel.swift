//
//  RecordViewModel.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftUI
import Speech

func requestPermissions() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        switch authStatus {
        case .authorized:
            print("Speech recognition authorized")
        case .denied, .restricted, .notDetermined:
            print("Speech recognition not authorized")
        default:
            break
        }
    }
    
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        if granted {
            print("Microphone access granted")
        } else {
            print("Microphone access denied")
        }
    }
}
