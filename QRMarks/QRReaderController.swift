//
//  qrReaderController.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class QRReaderController: ReaderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAuthorized() {
            captureSession?.startRunning()
        }
    }
}

