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
    var account: String
    var share: Bool = false
    
    init(topic: String, content: String, account: String) {
        id = UUID().uuidString
        self.topic = topic
        self.content = content
        self.account = account
    }
}

