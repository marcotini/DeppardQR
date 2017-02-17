//
//  Util.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

/// OCR Dimensions Max Value
let kTOCRDimensionsMax: CGFloat = 640

private let _URL_START : String = "https://qr-cards-4b4e2.firebaseio.com/Users"

/// Function To create the urls once its knows the uid, for the QR code
///
/// - Parameter uid: The Users UID that will send added to the url
/// - Returns: The URL for the serarched user
func createUrl(_ uid: String) -> String {
    return "\(_URL_START)/\(uid)"
}

/// UID creation variable
var uid: String {
    let uid = NSUUID()
    return uid.uuidString
}

var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInitiated)
}

/// A Function to raise an NSException that involves not supported `init`s without writting all the lines out over and over again
///
/// - Parameter function: The string name for a function that is to be used in place of the one calling the exception
func raiseInit(_ function: String) {
    NSException(name: .genericException, reason: "init() is not supported, please use \(function) instead", userInfo: nil).raise()
}

public extension UICollectionView {
    /// Allows for neater looking code
    func register(_ cell: AnyClass, for reuse: String) {
        self.register(cell, forCellWithReuseIdentifier: reuse)
    }
    
    /// This Should only be used if the reuse is the same as the cell name
    func register(_ cell: AnyClass) {
        self.register(cell, forCellWithReuseIdentifier: cell.string)
    }
    
    /// Shorter dequeue code snippet
    func dequeue(reuseCell: AnyClass, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: reuseCell.string, for: indexPath)
    }
}

extension NSObject {
    class var string: String {
        let className = self as AnyObject
        return NSStringFromClass(className as! AnyClass)
    }
}

extension Dictionary {
    
    /// Dictionary contains function that checks to see if the key value is equal to the string you are wanting to check for
    func keyIsEqual(_ string: String) -> Bool {
        for (key, _) in self {
            guard let keyValue = key as? String else {return false}
            
            if keyValue == string {
                return true
            }
        }
        
        return false
    }
}

