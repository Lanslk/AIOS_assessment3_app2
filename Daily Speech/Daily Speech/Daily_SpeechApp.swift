//
//  Daily_SpeechApp.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

@main
struct Daily_SpeechApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Activity.self)
        }
    }
}
