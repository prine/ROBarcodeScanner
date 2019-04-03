//
//  ROBarcodeScannerViewController.swift
//  ROBarcodeScanner
//
//  Inspired by the Tutorial from http://www.appcoda.com/qr-code-reader-swift/
//
//  Created by Robin Oster on 24/07/15.
//  Copyright (c) 2015 RASCOR International AG. All rights reserved.
//

import UIKit
import AVFoundation

public class ROBarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var videoView:UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var captureDevice:AVCaptureDevice?
    
    var lastCapturedCode:String?
    
    public var barcodeScanned:((String) -> ())?
    
    private var allowedTypes = [AVMetadataObject.ObjectType.upce,
                                AVMetadataObject.ObjectType.code39,
                                AVMetadataObject.ObjectType.code39Mod43,
                                AVMetadataObject.ObjectType.ean13,
                                AVMetadataObject.ObjectType.ean8,
                                AVMetadataObject.ObjectType.code93,
                                AVMetadataObject.ObjectType.code128,
                                AVMetadataObject.ObjectType.pdf417,
                                AVMetadataObject.ObjectType.qr,
                                AVMetadataObject.ObjectType.aztec]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the default capturing device for using the camera
        self.captureDevice = AVCaptureDevice.default(for: .video)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            if let captureDevice = self.captureDevice {
                input = try AVCaptureDeviceInput(device: captureDevice)
                
                if (error != nil) {
                    // If any error occurs, simply log the description of it and don't continue any more.
                    print("\(String(describing: error?.localizedDescription))")
                    return
                }
                
                // Initialize the captureSession object and set the input device on the capture session.
                captureSession = AVCaptureSession()
                captureSession?.addInput(input as! AVCaptureInput)
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = self.allowedTypes
                
                // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                
                if let captureSession = captureSession {
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
                    videoPreviewLayer?.frame = videoView.layer.bounds
                    videoView.layer.addSublayer(videoPreviewLayer!)
                    
                    // Start video capture.
                    captureSession.startRunning()
                    
                    // Move the message label to the top view
                    view.bringSubviewToFront(messageLabel)
                    
                    // Initialize QR Code Frame to highlight the QR code
                    qrCodeFrameView = UIView()
                    qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
                    qrCodeFrameView?.layer.borderWidth = 2
                    qrCodeFrameView?.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin, UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin]
                    
                    view.addSubview(qrCodeFrameView!)
                    view.bringSubviewToFront(qrCodeFrameView!)
                }
            }
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer?.frame = self.videoView.layer.bounds
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if let videoPreviewLayer = self.videoPreviewLayer {
            switch(orientation) {
            case UIInterfaceOrientation.landscapeLeft:
                videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                
            case UIInterfaceOrientation.landscapeRight:
                videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                
            case UIInterfaceOrientation.portrait:
                videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
            case UIInterfaceOrientation.portraitUpsideDown:
                videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                
            default:
                print("Unknown orientation state")
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        
    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        videoPreviewLayer?.frame = videoView.layer.bounds
    }
    
    // DIFFERENT FUNCTION, i fixed in maybe rascor?!
    // func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if self.allowedTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                lastCapturedCode = metadataObj.stringValue
                
                print("Scanned barcode: \(String(describing: metadataObj.stringValue))")
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.navigationController?.popViewController(animated: true)
        
        if let barcodeScannedTemp = barcodeScanned, let lastCapturedCodeTemp = lastCapturedCode  {
            // Notify via callback
            barcodeScannedTemp(lastCapturedCodeTemp)
        }
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
