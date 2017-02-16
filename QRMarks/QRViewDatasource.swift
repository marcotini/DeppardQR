//
//  qrViewDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import FIFIlter

class qrViewDatasource: QRDatasource {
    
    var controller: QRDelegate?
    var imageView: UIImageView!
    var image: UIImage!
    
    // Function to download user data that is shown on QR, end code this will be moved
    func downloadData(_ data: Dictionary<String, AnyObject>) {
        User.main.setup(user: uid, with: data)
        prepareUI()
    }
    
    // Function to prepare/create views before reloading the main vc UI, i.e filtering images or animating views
    func prepareUI() {
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
