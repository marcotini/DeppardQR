//
//  Test.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import AVFoundation
import TesseractOCR

typealias Detecting = (Void) -> Void

class UserCreationVC: ReaderViewController, CaptureSessionDelegate {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var cardView: UIImage?
    var clipImageView = UIImageView()
    
    override var frameWidth: CGFloat {
        return 350
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession?.startRunning()
        
        imageView.isHidden = true
        
        dectectData(from: imageView.image) {
            print(User.main.address ?? "Nothing to print")
            print(User.main.numbers ?? "Nothing to print")
            
            NSLog("FINISHED")
        }
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            takePhoto()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func captureSession(didTakePhoto photo: UIImage, with error: Error?) {
        if error == nil { /* Error Handle */ }
        
        clipImageView.image = photo
        let image = clipImage(from: clipImageView, forRect: frameRect(frameWidth, frameHeight))
        imageView.image = image
        imageView.isHidden = false
        
        self.dectectData(from: image) {
            self.captureSession?.stopRunning()
            self.view.bringSubview(toFront: self.backGroundView)
            
            NSLog("FINISHED")
        }
    }
    
    // MARK: Tesseract Interaction
    func detect(image: UIImage) -> String? {
        
        let tesseract = G8Tesseract(language: "eng", engineMode: .tesseractCubeCombined)
        tesseract?.pageSegmentationMode = .auto
        tesseract?.maximumRecognitionTime = 60.0
        tesseract?.image = scale(image: image, maxDimension: kTOCRDimensionsMax)
        tesseract?.recognize()
        
        guard let output = tesseract?.recognizedText else { return nil }
        print(output as Any)
        return output
    }
    
    func clipImage(from imageView: UIImageView, forRect rect: CGRect) -> UIImage? {
        let path = UIBezierPath(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        imageView.layer.mask = shapeLayer
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image2: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image2
    }
    
    func dectectData(from image: UIImage?, _ finish: @escaping Detecting) {
        GlobalUserInitiatedQueue.async {
            
            // Set the string to be 'detected' -> which is detcted from the image via TesseractOCR
            guard let string = self.detect(image: image!) else { finish(); return }
            
            // Set the types to be looking for
            let types: NSTextCheckingResult.CheckingType = [.address, .phoneNumber]
            
            // Creates the reference of the NSDataDetector
            let detector = try? NSDataDetector(types: types.rawValue)
            
            // Runs the detector match function and sets matches as the result
            if let matches = detector?.matches(in: string, options: .reportProgress, range: NSMakeRange(0, (string.utf16.count))) as [NSTextCheckingResult]? {
                
                // Enumeration over the `matches` and sets them as `match` with `forin` loop
                print(matches.count)
                
                for match in matches {
                    
                    if let email = match.url {
                        print(email)
                    }
                    
                    // Checks for address
                    if let address = match.addressComponents {
                        User.main.update(address)
                    }
                    
                    // Checks for phoneNumber
                    if let phoneNumber = match.phoneNumber {
                        User.main.update(phoneNumber)
                    }
                }
            }
            
            // Brings the thread back to the main and tells the function to finish
            DispatchQueue.main.sync {
                finish()
            }
        }
    }
}
