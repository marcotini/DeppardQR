//
//  Downloader.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

protocol FIRDownloadManager {
    var objects: [Posts] {get set}
    
    init?()
    
    init(withFIRReference ref: FIRDatabaseReference)
    
    init(_ uid: String?, withFIRReference ref: FIRDatabaseReference)
}

typealias Downloading = (_ post: Array<Any>) -> Void
typealias DownloadingUser = (_ uid: String, _ post: Dictionary<String, AnyObject>) -> Void

/**
 Firebase database download/upload manager
 */
class Downloader: FIRDownloadManager {
    
    /// Firebase Database reference that will be the base for all method calls
    private(set) var _firebaseRef: FIRDatabaseReference?
    
    /// UID for the user we are downloading
    ///
    /// Default may be removed
    private(set) var _uid: String? = "2EA66C20-4F71-45F7-8742-5816B9FD60F3"
    
    /// Array of Any, this allows all downloaded objects to be held before being sent back out.
    var objects: [Posts] = []
    
    required init?() {
        raiseInit("init(withFIRReference:)")
        return nil
    }
    
    /// Init call for most circumstances, sets the firebaseRef with the input ref
    required init(withFIRReference ref: FIRDatabaseReference) {
        self._firebaseRef = ref
    }
    
    /// Init call when downloading user data and needs to know the uid
    required init(_ uid: String?, withFIRReference ref: FIRDatabaseReference) {
        self._uid = uid ?? "2EA66C20-4F71-45F7-8742-5816B9FD60F3"
        self._firebaseRef = ref
    }
    
    /// Firebase database download method to return downloaded data
    ///
    /// - Parameter completion: The completion Handler contains an array of Any
    func downloadPostData(completion: @escaping Downloading) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        _firebaseRef?.queryOrdered(byChild: "company_name").observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    /// Function to download required user data.
    /// Internal call may be changed
    ///
    /// - Parameter completion: <#completion description#>
    func downloadUserData( _ completion: @escaping DownloadingUser) {
        guard let uid = _uid else { return }
        
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
    
    func addNewObject(_ uid: String, _ completion: @escaping (Void) -> Void) {
        _firebaseRef?.child(self._uid!).child("scanned").updateChildValues([uid:"true"])
        
        // Testing...
        _firebaseRef?.updateChildValues([uid:"true"])
        _firebaseRef?.child(uid).updateChildValues(["name":"nil"])
        
        // Need to update the objects variable inside of User because even if the database has the new uid it won't set it inside the objects array unless User.main.objects contains the uid
        User.main.update(uid)
        print(User.main.objects)
        
        completion()
    }
}
