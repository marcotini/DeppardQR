//
//  Anallytics.swift
//  QRMarks
//
//  Created by Harry Wright on 23/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation
import Firebase
import Crashlytics

/**  
 
 */
class Analytics {
    
    /**  */
    static func logLogin() {
        Answers.logLogin(withMethod: "Firebase", success: nil, customAttributes: nil)
    }
    
    /**  */
    static func logSignUp() {
        Answers.logSignUp(withMethod: "Firebase", success: nil, customAttributes: nil)
    }
    
    /**  */
    static func logQR(by user: User, for scannie: String) {
        let username = user.name ?? "unknown"
        
        Answers.logCustomEvent(withName: "QR Scanned", customAttributes: [
            "Scanned By" : username as NSObject,
            "Scanned Who" : scannie as NSObject
            ])
    }
    
    /**  */
    static func logError(by user: User?, for error: Error?) {
        guard let error = error else { return }
        var errorText = error.localizedDescription 
        let username = user?.name ?? "N/A"
        
        if errorText.characters.count > 100 {
            let endOfText = errorText.index(errorText.startIndex, offsetBy: 97)
            errorText = errorText.substring(to: endOfText)
            errorText += "..."
        }
        
        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: [
            "User" : username as NSObject,
            "Localized Description" : errorText as NSObject
            ])
    }
    
    /**  */
    static func logSearch(_ search: String, byUser user: User) {
        let username = user.name ?? "N/A"
        
        Answers.logSearch(withQuery: search, customAttributes: ["User" : username])
    }
}
