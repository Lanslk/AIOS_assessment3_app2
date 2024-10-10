//
//  Activity.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import SwiftData

@Model
class Activity: Identifiable {
    var id: String
    var topic: String
    var content: String
    var url: URL? = nil
    
    init(topic: String, content: String) {
        id = UUID().uuidString
        self.topic = topic
        self.content = content
    }
}

