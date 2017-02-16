//
//  Util.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

let kTOCRDimensionsMax: CGFloat = 640

let dict: [String: String] = [
    "name" : "Harry Wright",
    "company_name" : "RESDEV",
    "qr_url" : "https://social-media-clone.firebaseio.com/users/T8tSkLSKzsOiG4JsbguHnhU46vK2"
]

private let _URL_START : String = "https://qr-cards-4b4e2.firebaseio.com/Users"
func createUrl(_ uid: String) -> String {
    return "\(_URL_START)/\(uid)"
}

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
