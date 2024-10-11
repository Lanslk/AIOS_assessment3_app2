//
//  DataController.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftData
import FirebaseStorage


let mockActivities = [
    Activity(topic: "Mock Topic 1", content: "This is mock content 1.", account: "test@gmail.com"),
    Activity(topic: "Mock Topic 2", content: "This is mock content 2.", account: "test@gmail.com"),
    Activity(topic: "Mock Topic 3", content: "This is mock content 3.", account: "test@gmail.com")
]

// save activity into local spacce
func saveActivity(topic: String, content: String, account: String, context: ModelContext, url: URL?) {
    
    do {
        // Insert the new record
        let newActivity = Activity(topic: topic, content: content, account: account)
 
        if let audioURL = url {
            // Upload the audio file to Firebase
            uploadAudioToFirebase(audioURL: audioURL) { result in
                switch result {
                case .success(let downloadURL):
                    newActivity.url = downloadURL
                    print("Audio uploaded successfully: \(downloadURL)")
                case .failure(let error):
                    print("Failed to upload audio: \(error)")
                }
            }
        }
        
        context.insert(newActivity)
        
        // Save changes to the context
        try context.save()

    } catch {
        print("Failed to save activity: \(error)")
    }
}

// Update activity with new values
func updateActivity(activity: Activity, newTopic: String, newContent: String, context: ModelContext) {
    activity.topic = newTopic
    activity.content = newContent
    do {
        try context.save()
    } catch {
        print("Failed to update activity: \(error)")
    }
}

// Delete activity from local space
func deleteActivity(activity: Activity, context: ModelContext) {
    context.delete(activity)
    do {
        try context.save()
    } catch {
        print("Failed to delete activity: \(error)")
    }
}

func uploadAudioToFirebase(audioURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
    // Create a storage reference
    let storageRef = Storage.storage().reference()
    
    // Create a reference for the audio file in Firebase Storage
    let audioRef = storageRef.child("audio/\(UUID().uuidString).m4a")
    
    // Upload the file to Firebase Storage
    audioRef.putFile(from: audioURL, metadata: nil) { metadata, error in
        if let error = error {
            print("Error uploading file: \(error)")
            completion(.failure(error))
            return
        }
        
        // Fetch the download URL of the uploaded audio file
        audioRef.downloadURL { url, error in
            if let error = error {
                print("Error getting download URL: \(error)")
                completion(.failure(error))
            } else if let url = url {
                print("File uploaded successfully, download URL: \(url)")
                completion(.success(url))
            }
        }
    }
}
