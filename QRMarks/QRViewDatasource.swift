//
//  qrViewDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase
import FIFIlter

class qrViewDatasource: QRDatasource {
    
    @available(*, unavailable, message: "Not Currently Used")
    override func downloadData(withFIRReference ref: FIRDatabaseReference) {
        downloader = Downloader(withFIRReference: ref)
        
        downloader?.downloadUserData({ (string, dict) in
            User.main.setup(user: string, with: dict)
            self.downloader?.items = User.main.objects
            self.prepareUI()
        })
    }
    
    override func prepareUI() {
        image = createQR()
        controller?.reloadUI()
    }
}

private extension qrViewDatasource {
    
    // Private function to create QR code for main user
    func createQR() -> UIImage? {
        let message = User.main.qrUrl
        let value: [Parameter] = [(.inputCorrectionLevel, "H")]
        
        let qr = FIImage(message: message.data, imageView: imageView, parameters: value, effect: .CIQRCodeGenerator)
        
        return qr
    }
}
