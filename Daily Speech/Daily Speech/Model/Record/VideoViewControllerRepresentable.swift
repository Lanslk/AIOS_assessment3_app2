//
//  VideoViewControllerRepresentable.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI
import AVFoundation

struct VideoViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VideoViewController {
        return VideoViewController()
    }

    func updateUIViewController(_ uiViewController: VideoViewController, context: Context) {
        // Update logic (if needed) goes here
    }
}
