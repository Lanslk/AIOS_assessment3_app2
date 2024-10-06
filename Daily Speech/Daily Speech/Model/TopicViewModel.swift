//
//  TopicViewModel.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import Foundation

struct Category {
        let name: String
        let topics: [String]
    }
    
// Sample data for categories and topics
let categories: [Category] = [
    Category(name: "Daily Life & Routine", topics: ["Describe your daily routine", "Talk about a memorable day", "What do you like to do on weekends?"]),
    Category(name: "Travel & Culture", topics: ["Describe a place you want to visit", "Share a cultural tradition", "Talk about a memorable trip"]),
    Category(name: "Personal Interests & Hobbies", topics: ["Talk about your favorite hobby", "Describe a book or movie you love", "Share a skill you want to learn"]),
    Category(name: "Current Events & News", topics: ["Discuss a recent news story", "Talk about a global issue", "What is your opinion on climate change?"]),
    Category(name: "Future Goals & Aspirations", topics: ["Describe your dream job", "Share your 5-year goals", "What is something you want to achieve?"])
]
