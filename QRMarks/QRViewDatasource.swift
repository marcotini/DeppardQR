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
    
    init(withImageView imageView: UIImageView ) {
        super.init()
        
        self.imageView = imageView
    }
    
    override func prepareUI() {
        guard let image = createQR() else { fatalError("No QR CODE") }
        
        controller?.reloadUI(with: image)
    }
    
    override func upload(data: Any, to ref: FIRDatabaseReference) {
        downloader = DownloadManager(withFIRReference: ref)
        
//        downloader?.addNewObjects((data as? String)!) {
//            print(data)
//        }
    }
    
    // Private function to create QR code for main user
    private func createQR() -> UIImage? {
        let message = createUrl(User.main.qrUrl!) //User.main.qrUrl
        let value: [Parameter] = [(.inputCorrectionLevel, "H")]
        
        print(message as Any)
        return FIImage(
            message: message.data,
            imageView: imageView,
            parameters: value,
            effect: .CIQRCodeGenerator
        )
    }
}
