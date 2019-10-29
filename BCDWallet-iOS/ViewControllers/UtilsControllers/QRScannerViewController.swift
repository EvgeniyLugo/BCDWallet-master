//
//  QRScannerViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 08/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScannerDelegate:class {
    func qrScannerFinished(_ result: String) -> Void
}

class QRScannerViewController: UIViewController {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var qrCodeImageView: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!

    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

//    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
//                                      AVMetadataObject.ObjectType.code39,
//                                      AVMetadataObject.ObjectType.code39Mod43,
//                                      AVMetadataObject.ObjectType.code93,
//                                      AVMetadataObject.ObjectType.code128,
//                                      AVMetadataObject.ObjectType.ean8,
//                                      AVMetadataObject.ObjectType.ean13,
//                                      AVMetadataObject.ObjectType.aztec,
//                                      AVMetadataObject.ObjectType.pdf417,
//                                      AVMetadataObject.ObjectType.itf14,
//                                      AVMetadataObject.ObjectType.dataMatrix,
//                                      AVMetadataObject.ObjectType.interleaved2of5,
//                                      AVMetadataObject.ObjectType.qr]
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    private var scannedText = ""
    
    public weak var qrScannerDelegate: QRScannerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.isHidden = true
        
        moveIn()
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = qrCodeImageView.frame
        videoPreviewLayer?.cornerRadius = 16
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        view.bringSubviewToFront(qrCodeImageView)
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            messageLabel.text = "No QR code is detected"
            scannedText = ""
            copyButton.isEnabled = false
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
//            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
//            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)

//            // read from clipboard
//            let content = UIPasteboard.general.string
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                scannedText = metadataObj.stringValue!
                copyButton.isEnabled = true
            }
        }
    }    
}

extension QRScannerViewController {
    @IBAction func copyClicked(_ sender: Any) {
        // write to clipboard
        UIPasteboard.general.string = scannedText
        animateForward()
    }
    
    @IBAction func okClicked(_ sender: Any) {
        if let delegate = self.qrScannerDelegate {
            delegate.qrScannerFinished(scannedText)
        }
        moveOut()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        UIPasteboard.general.string = ""
        if let delegate = self.qrScannerDelegate {
            delegate.qrScannerFinished("")
        }
        moveOut()
    }
    
    private func moveIn() {
        self.view.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        self.view.alpha = 0.2
        UIView.animate(withDuration: 1.25,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.view.alpha = 1.0
        }, completion: nil)
    }
    
    private func moveOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    private func animateForward() {
        self.okButton.isHidden = false
        self.okButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.okButton.alpha = 0
        UIView.animate(withDuration: 0.25,
                       animations: { () -> Void in
                        self.okButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        self.okButton.alpha = 1
        }) { (succeed) -> Void in
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.okButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
}
