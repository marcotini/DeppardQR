//
//  Anallytics.swift
//  QRMarks
//
//  Created by Harry Wright on 23/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation
import Firebase

class Analytics {
    
    static func logQR(by user: User, for scannie: String) {
        FIRAnalytics.logEvent(withName: "QR Scanned", parameters: [
            "Scanned By" : user.name! as NSObject,
            "Scanned Who" : scannie as NSObject
            ])
    }
    
}
