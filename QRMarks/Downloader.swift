//
//  Downloader.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

typealias Downloading = (_ post: Array<Any>) -> Void
typealias DownloadingUser = (_ uid: String, _ post: Dictionary<String, AnyObject>) -> Void

class Downloader {
    
    private(set) var _firebaseRef: FIRDatabaseReference?
    var objects: [Any] = []
    var uid: String? = "2EA66C20-4F71-45F7-8742-5816B9FD60F3"
    var items: Dictionary<String, AnyObject> = [:]
    
    init?() {
        raiseInit("init(withFIRReference:)")
        return nil
    }
    
    init(withFIRReference ref: FIRDatabaseReference) {
        self._firebaseRef = ref
    }
    
    func downloadPostData(completion: @escaping Downloading) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        _firebaseRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            self.objects.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        if User.main.objects.keyIsEqual(key) {
                            let posts = Posts(key, dict: postDict)
                            self.objects.append(posts)
                        }
                    }
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(self.objects.reversed())
        })
    }
    
    /// Function to download required user data
    func downloadUserData( _ completion: @escaping DownloadingUser) {
        guard let uid = uid else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        _firebaseRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        if key == uid {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            completion(uid, userDict)
                            return
                        }
                    }
                }
            }
        })
    }
    
    func addNewObject(_ uid: String, _ completion: @autoclosure (Void) -> Void) {
        _firebaseRef?.child("/scanned").setValue([uid:"true"])
        completion()
    }
}
