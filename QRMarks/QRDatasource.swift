//
//  QRDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 17/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

class QRDatasource: Datasource {
    var controller: QRDelegate?
    var imageView: UIImageView!
    var image: UIImage!
    var downloader: Downloader?
    
    func downloadData(withFIRReference ref: FIRDatabaseReference) { }
    
    func prepareUI() { }
}
