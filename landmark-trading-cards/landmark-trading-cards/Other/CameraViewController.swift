//
//  CameraViewController.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/31/24.
//

import AVFoundation
import UIKit
import SwiftUI
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session: AVCaptureSession?
    @Binding var recognizedLandmarks: String
    
    private var requests = [VNRequest]()
    
    init(recognizedLandmarks: Binding<String>) {
        self._recognizedLandmarks = recognizedLandmarks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
    }
    
    private func setupCamera() {
        session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("CameraViewController: No video device found")
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("CameraViewController: Could not create video input")
            return
        }
        session?.addInput(input)
        session?.startRunning()
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session?.addOutput(output)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        print("CameraViewController: Camera setup complete")
    }
    
    private func setupVision() {
        print("setting up vision")
        return
//        guard let model = try? VNCoreMLModel(for: YourMLModel().model) else {
//            print("CameraViewController: Could not load Vision model")
//            return
//        }
//        
//        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
//            if let observations = request.results as? [VNRecognizedObjectObservation] {
//                let recognizedLandmarks = observations.map { $0.labels.first?.identifier ?? "" }.joined(separator: ", ")
//                DispatchQueue.main.async {
//                    self?.recognizedLandmarks = recognizedLandmarks
//                    print("CameraViewController: Recognized landmarks: \(recognizedLandmarks)")
//                }
//            }
//        }
//        requests = [request]
//        
//        print("CameraViewController: Vision setup complete")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("CameraViewController: Could not get pixel buffer")
            return
        }
        
        var requestOptions: [VNImageOption: Any] = [:]
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: requestOptions)
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("CameraViewController: Vision request failed: \(error)")
        }
    }
}



