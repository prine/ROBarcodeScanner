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
    
    private var allowedTypes = [AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeAztecCode]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the default capturing device for using the camera
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device:captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object and set the input device on the capture session.
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = self.allowedTypes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResize
        videoPreviewLayer?.frame = videoView.layer.bounds
        videoView.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.redColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        qrCodeFrameView?.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer?.frame = self.videoView.layer.bounds
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        switch(orientation) {
        case UIInterfaceOrientation.LandscapeLeft:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            
        case UIInterfaceOrientation.LandscapeRight:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
            
        case UIInterfaceOrientation.Portrait:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            
        case UIInterfaceOrientation.PortraitUpsideDown:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown
            
        default:
            print("Unknown orientation state")
        }
    }
    
    public override func viewDidLayoutSubviews() {
        
    }
    
    public override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        videoPreviewLayer?.frame = videoView.layer.bounds
    }
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if self.allowedTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                lastCapturedCode = metadataObj.stringValue
            }
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.navigationController?.popViewControllerAnimated(true)
        
        if let barcodeScannedTemp = barcodeScanned, lastCapturedCodeTemp = lastCapturedCode  {
            // Notify via callback
            barcodeScannedTemp(lastCapturedCodeTemp)
        }
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
