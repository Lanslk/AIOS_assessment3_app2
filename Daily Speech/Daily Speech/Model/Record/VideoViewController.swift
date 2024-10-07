//
//  VideoViewController.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import Foundation
import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoOutput: AVCaptureMovieFileOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        
        let recordButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        recordButton.setTitle("Record", for: .normal)
        recordButton.backgroundColor = .red
        recordButton.addTarget(self, action: #selector(startRecordingButtonTapped), for: .touchUpInside)
        view.addSubview(recordButton)
        
        let stopButton = UIButton(frame: CGRect(x: 220, y: 100, width: 100, height: 50))
        stopButton.setTitle("Stop", for: .normal)
        stopButton.backgroundColor = .gray
        stopButton.addTarget(self, action: #selector(stopRecordingButtonTapped), for: .touchUpInside)
        view.addSubview(stopButton)
    }
    
    @objc func startRecordingButtonTapped() {
        startRecording()
    }

    @objc func stopRecordingButtonTapped() {
        stopRecording()
    }
    
    func setupCaptureSession() {
        // Initialize session
        captureSession = AVCaptureSession()
        
        // Set session preset
        captureSession?.sessionPreset = .high
        
        // Add camera input
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Error accessing camera")
            return
        }
        if captureSession?.canAddInput(input) ?? false {
            captureSession?.addInput(input)
        }
        
        // Add microphone input
        guard let microphone = AVCaptureDevice.default(for: .audio),
              let micInput = try? AVCaptureDeviceInput(device: microphone) else {
            print("Error accessing microphone")
            return
        }
        if captureSession?.canAddInput(micInput) ?? false {
            captureSession?.addInput(micInput)
        }
        
        // Add video output
        videoOutput = AVCaptureMovieFileOutput()
        if let output = videoOutput, captureSession?.canAddOutput(output) ?? false {
            captureSession?.addOutput(output)
        }
        
        // Add preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        if let layer = previewLayer {
            view.layer.addSublayer(layer)
        }
        
        // Start session
        captureSession?.startRunning()
    }
    
    // Start recording
    func startRecording() {
        guard let output = videoOutput else { return }
        let filePath = NSTemporaryDirectory() + "temp.mov"
        let fileURL = URL(fileURLWithPath: filePath)
        output.startRecording(to: fileURL, recordingDelegate: self)
    }
    
    // Stop recording
    func stopRecording() {
        videoOutput?.stopRecording()
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo fileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
        } else {
            print("Recording finished successfully, file is saved at \(fileURL)")
            // Handle the recorded file (e.g., save it to the photo library, share it, etc.)
        }
    }
}
