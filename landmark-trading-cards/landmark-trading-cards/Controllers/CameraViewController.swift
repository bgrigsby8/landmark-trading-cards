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
import CoreML

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session: AVCaptureSession?
    @Binding var recognizedLandmarks: String
    
    private var requests = [VNRequest]()
    private var locationDataManager: LocationDataManager?
    
    init(recognizedLandmarks: Binding<String>, locationDataManager: LocationDataManager) {
        self._recognizedLandmarks = recognizedLandmarks
        self.locationDataManager = locationDataManager
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
        let config = MLModelConfiguration()
        // MobileNetV3 is the name of the image classification model
        guard let coreMLModel = try? MobileNetV3(configuration: config) else {
            print("CameraViewController: Could not load CoreML model")
            return
        }
        print("CameraViewController: coreMLModel loaded: \(coreMLModel.model.modelDescription)")
        
        guard let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {
            print("CameraViewController: Could not create Vision model")
            return
        }
        
        print("CameraViewController: visionModel loaded: \(visionModel)")
        
        let request = VNCoreMLRequest(model: visionModel) { [weak self] (request, error) in
            if let error = error {
                print("CameraViewController: Vision request error: \(error)")
                return
            }
            
            if let observations = request.results as? [VNClassificationObservation], let bestResult = observations.first {
                print("Identifier: \(bestResult.identifier), Confidence: \(bestResult.confidence)")
                
                DispatchQueue.main.async {
                    self?.recognizedLandmarks = bestResult.identifier
                    print("\(self?.locationDataManager?.inLandmark ?? "Error")")
                    
                    if let inLandmark = self?.locationDataManager?.inLandmark, !inLandmark.isEmpty {
                        if inLandmark == bestResult.identifier && bestResult.confidence > 0.5 {
                            // Unlock the trading card here
                            self?.unlockTradingCard(for: bestResult.identifier)
                        }
                    }
                }
            } else {
                print("CameraViewController: No observations found")
            }
        }
        
        request.imageCropAndScaleOption = .centerCrop
        requests = [request]
    }
    
    private func unlockTradingCard(for landmark: String) {
        print("Unlocking trading card for: \(landmark)")
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
