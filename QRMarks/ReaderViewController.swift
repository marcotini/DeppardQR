//
//  ReaderViewController.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import AVFoundation
import FIFIlter
import TesseractOCR

typealias AVAuth = AVAuthorizationStatus
typealias InputDevice = AVCaptureDevice
typealias AVReadableCode = AVMetadataMachineReadableCodeObject

class ReaderViewController: UIViewController {
    
    // MARK: Properties
    
    private var _returnValue: Bool = true
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var stillImage: AVCaptureStillImageOutput?
    var readerFrameView: UIView?
    var error: Error?
    var delegate: CaptureSessionDelegate?
    
    var frameWidth: CGFloat {
        return 200
    }
    
    var frameHeight: CGFloat {
        return 200
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the camera input up, if error makes it through setup, returns out of the VDL else creates the views
        self.setUpCameraInput { (error, input) in
            if error != nil {
                self.error = error
                return
            }
            
            self.error = error
            self.viewCreation(with: input)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Will set the readerFrameView back to the center when a subclassed view is pushed on
        readerFrameView?.bounds = self.frameRect(frameWidth, frameHeight)
    }
    
    // MARK: Checks
    
    // Checks for request access with camera
    func isAuthorized() -> Bool {
        if InputDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuth.authorized {
            return _returnValue
        } else {
            InputDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if granted {
                    self._returnValue = true
                } else {
                    self._returnValue = false
                }
            })
            
            NSLog(_returnValue.description)
            return _returnValue
        }
    }
}

// MARK: - Image Functions to be used in subclasses
extension ReaderViewController {
    func scale(image: UIImage, maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

// MARK: - View Creation
private extension ReaderViewController {

    /// Function used as custom error handler, runs first to check if device can capture video
    func setUpCameraInput(_ completion: @escaping (Error?, AnyObject?) -> Void) {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input: AnyObject? = try AVCaptureDeviceInput(device: captureDevice)
            completion(nil, input)
        } catch {
            completion(error, nil)
        }
    }

    /// Function to call the setup functions, manager like function
    func viewCreation(with input: AnyObject?) {
        
        setupCaptureSession(input!)
        
        setupPreviewLayer()
        
        setupFrame(frameWidth: self.frameWidth, height: self.frameHeight)
    }
    
    /// Function to set AVCaptureVideoPreviewLayer
    func setupPreviewLayer() {
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoPreviewLayer?.frame = self.view.layer.bounds
        self.view.layer.addSublayer(self.videoPreviewLayer!)
    }
    
    func setupStillImage() {
        stillImage = AVCaptureStillImageOutput()
        stillImage?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
    }
    
    /// Function to set the AVCaptureSession
    func setupCaptureSession(_ input: AnyObject?) {
        self.captureSession = AVCaptureSession()
        self.captureSession?.addInput(input as! AVCaptureInput)
        
        setupStillImage()
        let captureMetadataOutput = AVCaptureMetadataOutput()
        self.captureSession?.addOutput(captureMetadataOutput)
        self.captureSession?.addOutput(stillImage)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    /// Function to set the frame up
    func setupFrame(frameWidth width: CGFloat, height: CGFloat) {
        readerFrameView = UIView(frame: frameRect(width, height))
        readerFrameView?.layer.borderColor = UIColor.green.cgColor
        readerFrameView?.layer.borderWidth = 2
        
        view.addSubview(readerFrameView!)
        view.bringSubview(toFront: readerFrameView!)
    }
    
    /// Function to setup reader frame rect, used to help reset view
    func frameRect(_ width: CGFloat, _ height: CGFloat) -> CGRect {
        let frame = CGSize(width: width, height: height)
        let centerX = view.center.x - (frame.width / 2)
        let centerY = view.center.y - (frame.height / 2)
        let rect = CGRect(x: centerX, y: centerY, width: frame.width, height: frame.height)
        
        return rect
    }
    
//    func crop(_ image: UIImage, _ rect: CGRect) -> UIImage? {
//        
//        var rect = rect
//        rect.origin.x *= image.scale
//        rect.origin.y *= image.scale
//        rect.size.width *= image.scale
//        rect.size.height *= image.scale
//        
//        rect.applying(flipContextVertically(rect.size))
//        
//        let cgImage = image.cgImage!.cropping(to: rect)!
//        return UIImage(cgImage: cgImage)
//    }
    
    func flipContextVertically(_ contentSize: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransform()
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -contentSize.height)
        
        return transform
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ReaderViewController :  AVCaptureMetadataOutputObjectsDelegate {
    
    // Function that shows the recorded metadata
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            readerFrameView?.frame = frameRect(frameWidth, frameHeight)
            NSLog("No QR code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVReadableCode
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVReadableCode) as! AVReadableCode
            readerFrameView?.frame = barCodeObject.bounds;
            
            guard (metadataObj.stringValue) != nil else { return }
            delegate?.captureSession?(
                didCaptureMetadataObject: metadataObj,
                withOutput: metadataObj.stringValue
            )
        }
    }
    
    func takePhoto() {
        if let videoConnection = stillImage?.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            stillImage?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) in
                
                if error != nil {
                    print("\(error)")
                    self.delegate?.captureSession?(didTakePhoto: UIImage(), with: error)
                }
                
                if sampleBuffer != nil {
                    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer!, previewPhotoSampleBuffer: nil)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    self.delegate?.captureSession?(didTakePhoto: image, with: nil)
                }
            })
        }
    }
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
//        var rect = rect
//        rect.origin.x*=self.scale
//        rect.origin.y*=self.scale
//        rect.size.width*=self.scale
//        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!)
        return image
    }
}
