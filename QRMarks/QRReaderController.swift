//
//  qrReaderController.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import AVFoundation

class QRReaderController: ReaderViewController, CaptureSessionDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isAuthorized() {
            captureSession?.startRunning()
        }
        
        if error != nil { createAlert((error?.localizedDescription)!); return }
    }
    
    func captureSession(didCaptureMetadataObject object: AVReadableCode, withOutput string: String) {
        caughtCode(string)
    }
    
    func caughtCode(_ data: String) {
        captureSession?.stopRunning()
        createAlert(with: data)
    }
    
    // MARK: Alert Creation
    
    // Alert for when the session cannot be captured
    func createAlert(_ error: String)  {
        let alert = UIAlertController(title: "Error With Camera", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Back To Home", style: .cancel) { (action) in
            self.tabBarController?.selectedIndex = 0
        }
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Alert for when QR is scanned
    func createAlert(with qrString: String?) {
        guard let string = removeUrl(fromData: qrString!) else { return }
        print(string as Any)
        
        let alert = UIAlertController(title: "QR Scanned", message: "A new QR code has been scanned", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.captureSession?.startRunning()
        }
        let defaultAction = UIAlertAction(title: "Accept", style: .default) { (action) in
            Analytics.logQR(by: User.main, for: string)
            
            // Sets the upload manager and calls the `addNewObjects` method
            let downloadManager = DownloadManager(User.main.uid!,
                                                  withFIRReference: DataService.Singleton.REF_USERS)
            downloadManager.addNewObjects(withUUID: string) {
                self.tabBarController?.selectedIndex = 0
            }
        }
        
        alert.addAction(defaultAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

