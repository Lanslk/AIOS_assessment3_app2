//
//  DataController.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftData


let mockActivities = [
    Activity(topic: "Mock Topic 1", content: "This is mock content 1."),
    Activity(topic: "Mock Topic 2", content: "This is mock content 2."),
    Activity(topic: "Mock Topic 3", content: "This is mock content 3.")
]

// save activity into local spacce
func saveActivity(topic: String, content: String, context: ModelContext, url: URL?) {
    
    do {
        // Insert the new record
        let newActivity = Activity(topic: topic, content: content)
        newActivity.url = url
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
