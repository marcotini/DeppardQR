//
//  CaptureSessionDelegate.swift
//  QRMarks
//
//  Created by Harry Wright on 01/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Capture Session Delegate to handle when a photo is taken or barcode is scanned
 
 This is done to simplfy the ReaderViewController, so it will only contain the functions to setup the capture session, take the photo and capture the metadata object
 */
@objc protocol CaptureSessionDelegate {
    @objc optional func captureSession(didTakePhoto photo: UIImage, with error: Error?)
    @objc optional func captureSession(didCaptureMetadataObject object: AVReadableCode, withOutput string: String)
}
