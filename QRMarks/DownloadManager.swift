//
//  Downloader.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

//protocol DownloadManagerDatasource: class {
//    func downloadManager(didDownload userData: Dictionary<String, AnyObject>, for uid: String)
//}
//
//typealias Downloading = (_ post: Array<Any>) -> Void
//typealias DownloadingUser = (_ uid: String, _ post: Dictionary<String, AnyObject>) -> Void

/**
 Firebase database download/upload manager
 */
class DownloadManager: Downloadable, Uploadable {
    
    private(set) var _firebaseRef: FIRDatabaseReference?
    
    private(set) var _uid: String?
    
    var objects: [Any] = []
    
    var datasource: Datasource?
    
    var delegate: DownloadManagerDelegate?
    
    var queryByChild: String?
    
    required init?() {
        raiseInit("init(withFIRReference:)")
        return nil
    }
    
    init(withFIRReference ref: FIRDatabaseReference) {
        self._firebaseRef = ref
    }
    
    init(_ uid: String?, withFIRReference ref: FIRDatabaseReference) {
        self._uid = uid ?? "2EA66C20-4F71-45F7-8742-5816B9FD60F3"
        self._firebaseRef = ref
    }
    
    func downloadFirebaseObjects() {
        self.downloadFirebaseObjects { (posts) in
            self.delegate?.downloadManager(didDownload: posts)
        }
    }
    
    func downloadFirebaseUserObjects(with uid: String? = nil) {
        if self._uid == nil && uid != nil {
            self._uid = uid
        }
        
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
    
    func addNewObjects(with uid: String?, _ completion: @escaping (Void) -> Void) {
        _firebaseRef?.child(self._uid!).child("scanned").updateChildValues([uid!:"true"])
        
        // Testing...
        _firebaseRef?.updateChildValues([uid!:"true"])
        _firebaseRef?.child(uid!).updateChildValues(["name":"nil"])
        
        // Need to update the objects variable inside of User because even if the database has the new uid it won't set it inside the objects array unless User.main.objects contains the uid
        User.main.update(uid!)
        print(User.main.objects)
        
        completion()
    }
}
