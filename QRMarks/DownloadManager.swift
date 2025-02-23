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

let fibonacci = sequence(state: (0, 1)) {
    (state: inout (Int, Int)) -> Int? in
    defer {state = (state.1, state.0 + state.1)}
    return state.0
}

let interval = fibonacci.prefix{ $0 < 1000 }.drop{ $0 < 100 }

/**
 Firebase database download/upload manager
 */
class DownloadManager: Networkable {
    
    private(set) var _firebaseRef: FIRDatabaseReference?
    
    private(set) var _uid: String?
    
    var objects: [Any] = []
    
    var datasource: HWDatasource?
    
    var delegate: NetworkManagerDelegate?
    
    var queryByChild: String?

    required init?() {
        raise(init: "init(withFIRReference:)")
        return nil
    }
    
    init(withFIRReference ref: FIRDatabaseReference) {
        print(#function)
        self._firebaseRef = ref
    }
    
    init(_ uid: String, withFIRReference ref: FIRDatabaseReference) {
        print(#function)
        self._uid = uid
        self._firebaseRef = ref
    }
}

// MARK: - Download Methods

extension DownloadManager {
    
    func downloadObjects() {
        print(#function)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.downloadObjects { (posts) in
            self.delegate?.networkManager?(self, didDownload: posts)
        }
    }
    
    func downloadUserObjects() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        isUIDInitalised(for: #function)
        
        downloadUserObjects { (uid, userData) in
            self.delegate?.networkManager?(self, didDownload: userData, for: uid)
        }
    }
    
    func downloadObjects(completion: @escaping Downloading) {
        guard queryByChild != nil else { fatalError("No child to query with") }
        print(#function)
        
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
    
    func downloadUserObjects(completion: @escaping DownloadingUser) {
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
//                            return
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
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
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion()
            })
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    
    static func organise(
        _ userDetails: Dictionary<AnyHashable, Any>,
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
