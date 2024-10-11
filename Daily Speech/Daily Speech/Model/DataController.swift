//
//  DataController.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftData
import FirebaseStorage
import FirebaseFirestore

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
func updateActivity(activity: Activity, newTopic: String, newContent: String, newShare: Bool, context: ModelContext) {
    activity.topic = newTopic
    activity.content = newContent
    activity.share = newShare
    do {
        try context.save()
        if (newShare == true) {
            uploadActivityToFirebase(activity: activity)
        } else {
            deleteActivityFromFirebase(activityID: activity.id)
        }
        
    } catch {
        print("Failed to update activity: \(error)")
    }
}

// Delete activity from local space
func deleteActivity(activity: Activity, context: ModelContext) {
    context.delete(activity)
    do {
        try context.save()
        deleteActivityFromFirebase(activityID: activity.id)
    } catch {
        print("Failed to delete activity: \(error)")
    }
}

// Upload activity to firebase (share to cloud)
func uploadActivityToFirebase(activity: Activity) {
    let db = Firestore.firestore()
    let activityData: [String: Any] = [
        "id": activity.id,
        "topic": activity.topic,
        "content": activity.content,
        "url": activity.url?.absoluteString ?? "",
        "userAccount": activity.account,
        "share": activity.share
    ]
    
    // This will either update or create a new document with the same ID
    db.collection("activities").document(activity.id).setData(activityData, merge: true) { error in
        if let error = error {
            print("Error uploading activity: \(error)")
        } else {
            print("Activity successfully uploaded!")
        }
    }
}

// delete activity to firebase
func deleteActivityFromFirebase(activityID: String) {
    let db = Firestore.firestore()
    
    // Reference the document by its ID and delete it
    db.collection("activities").document(activityID).delete { error in
        if let error = error {
            print("Error deleting activity: \(error)")
        } else {
            print("Activity successfully deleted!")
        }
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

// Function to fetch data from Firestore
//class DataController {
//    private
//
//    // Function to fetch data from Firestore and return the result through a closure
//    func fetchActivities(for userAccount: String, limit: Int = 10, completion: @escaping ([Activity]) -> Void) {
//        let db = Firestore.firestore()
//        db.collection("activities")
//            .limit(to: limit)
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("Error fetching activities: \(error)")
//                    completion([])  // Return an empty array on error
//                } else {
//                    let activities = querySnapshot?.documents.compactMap { document -> Activity? in
//                        let data = document.data()
//                        let id = document.documentID
//                        let topic = data["topic"] as? String ?? "No Topic"
//                        let content = data["content"] as? String ?? ""
//                        let urlString = data["url"] as? String
//                        let url = URL(string: urlString ?? "")
//                        let share = data["share"] as? Bool ?? false
//                        let userAccount = data["userAccount"] as? String ?? ""
//                        
//                        return Activity(id: id, topic: topic, content: content, url: url, share: share, userAccount: userAccount)
//                    } ?? []
//                    completion(activities)  // Return the fetched activities
//                }
//            }
//
//    }
//}


func fetchActivities(limit: Int = 10, completion: @escaping ([Activity]) -> Void) {
    let db = Firestore.firestore()
    
    // Explicitly specify that we are using the `getDocuments(completion:)` method
    db.collection("activities")
        .limit(to: limit)
        .getDocuments(completion: { (querySnapshot, error) in  // Explicit completion label
            if let error = error {
                print("Error fetching activities: \(error)")
                completion([])  // Return an empty array on error
            } else {
                let activities = querySnapshot?.documents.compactMap { document -> Activity? in
                    let data = document.data()
                    let id = document.documentID
                    let topic = data["topic"] as? String ?? "No Topic"
                    let content = data["content"] as? String ?? ""
                    let urlString = data["url"] as? String
                    let url = URL(string: urlString ?? "")
                    let share = data["share"] as? Bool ?? false
                    let userAccount = data["userAccount"] as? String ?? ""
                    
                    return Activity(topic: topic, content: content, account: userAccount)
                } ?? []
                completion(activities)  // Return the fetched activities
            }
        })
}
