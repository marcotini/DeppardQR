//
//  QRDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 17/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

class QRDatasource {
    
    /// Controller to set up the Delegate
    weak var controller: QRDelegate?
    
    /// UIImageView to be used by the QR Filter
    var imageView: UIImageView!
    
    /// Image to hold the QR Code
    var image: UIImage!
    
    /// Download Manager, Only Used for testing
    var downloader: DownloadManager?
    
    /// For Testing
    func downloadData(withFIRReference ref: FIRDatabaseReference) { }
    
    /// For Testing
    func upload(data: Any, to ref: FIRDatabaseReference) { }
    
    ///
    func prepareUI() { }
}
