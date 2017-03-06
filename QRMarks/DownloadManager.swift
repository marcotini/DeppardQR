//
//  Downloader.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import HWCollectionView
import Firebase

/**
 Firebase database download/upload manager
 */
class DownloadManager: Networkable {
    
    private(set) var _firebaseRef: FIRDatabaseReference?
    
    private(set) var _uid: String?
    
    var objects: [Any] = []
    
    var datasource: Datasource?
    
    var delegate: DownloadManagerDelegate?
    
    var queryByChild: String?
    
    required init?() {
        raise(init: "init(withFIRReference:)")
        return nil
    }
    
    init(withFIRReference ref: FIRDatabaseReference) {
        self._firebaseRef = ref
    }
    
    init(_ uid: String, withFIRReference ref: FIRDatabaseReference) {
        self._uid = uid
        self._firebaseRef = ref
    }
}

// MARK: - DownloadManager

extension DownloadManager {

    func downloadFirebaseObjects() {
        self.downloadFirebaseObjects { (posts) in
            self.delegate?.downloadManager(didDownload: posts)
        }
    }
    
    func downloadFirebaseUserObjects(with uid: String? = nil) {
        isUIDInitalised(for: #function)
        
        downloadFirebaseUserObjects { (uid, userData) in
            self.delegate?.downloadManager(didDownload: userData, for: uid)
        }
    }
    
    func downloadFirebaseObjects(completion: @escaping Downloading) {
        guard queryByChild != nil else { fatalError("No child to query with") }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        _firebaseRef?.queryOrdered(byChild: queryByChild!).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    func downloadFirebaseUserObjects(completion: @escaping DownloadingUser) {
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
}

// MARK: - Upload Methods

extension DownloadManager {
    
    func addNewObjects(withUUID uid: String, _ completion: @escaping Uploading) {
        isUIDInitalised(for: #function)
        
        if User.main.objects.isEmpty {
            _firebaseRef?.child(self._uid!).updateChildValues(["scanned" : "null"])
        }
        
        // check to see if already scanned
        if !User.main.objects.contains(key: uid) {
            // sets up the dictionary
            let dict = [uid : "true"]
            
            // Updates the database
            _firebaseRef?.child(self._uid!).child("scanned").updateChildValues(dict)
            
            // calls the internal downloading function
            internalDownloading({ (objects) in
                
                // Updates the `user.main.objects`
                User.main.update(objects: objects)
                
                // Ends the completion handler
                completion()
            })
        } else {
            completion()
        }
    }
    
    func updateUser(withObjects objects: Dictionary<AnyHashable, Any>, _ completion: @escaping Uploading) {
        
        if self._uid != nil {
            _firebaseRef?.child(self._uid!).updateChildValues(objects)
        }
        
        completion()
    }
    
    private func internalDownloading(_ completion: @escaping (Dictionary<String, AnyObject>) -> Void) {
        isUIDInitalised(for: #function)
        // Initalised the dictionary
        var dict: Dictionary<String, AnyObject> = [:]
        
        // starts the download for the scanned items
        _firebaseRef?.child(self._uid!).child("scanned").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
                    // Updates the dictionary to become like [uid:"true"]
                    dict.updateValue("true" as AnyObject, forKey: snap.key)
                }
            }
            
            // ends the completion handler
            completion(dict)
        })
    }
    
    fileprivate func isUIDInitalised(for function: String) {
        if self._uid == nil {
            fatalError("No uid initalised, please use `init(_:withFIRReference:)` instead if wishing to use `\(function)`")
        }
    }
}

/**
 An organiser for the infomation before it uploaded to firebase
 */
class FirebaseUploaderOrganiser {
    
    static func organise(_ userDetails: Dictionary<AnyHashable, Any>,
                         _ address: [String]?,
                         _ numbers: [String]?) -> Dictionary<AnyHashable, Any>? {
        guard address != nil && numbers != nil else { return userDetails }
        var dict = userDetails as Dictionary<AnyHashable, Any>
        
        if address != nil {
            dict.updateValue(address as Any, forKey: "address")
        }
        
        if numbers != nil {
            dict.updateValue(numbers as Any, forKey: "numbers")
        }
        
        return dict
    }
    
}

extension Dictionary {
    func contains(key: String) -> Bool {
        return self.keyIsEqual(key)
    }
}
