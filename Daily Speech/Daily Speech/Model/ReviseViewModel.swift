//
//  ReviseViewModel.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftData

// save activity into local spacce
func saveActivity(topic: String, content: String, context: ModelContext) {
    
    do {
        // Insert the new record
        let newActivity = Activity(topic: topic, content: content)
        context.insert(newActivity)
        
        // Save changes to the context
        try context.save()

    } catch {
        print("Failed to save activity: \(error)")
    }
}
