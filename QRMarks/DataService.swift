//
//  DataService.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    // MARK: - Singleton Init
    
    static let Singleton = DataService()
    
    // MARK: - DB Refernces
    
    fileprivate var _REF_BASE = DB_BASE
    fileprivate var _REF_USERS = DB_BASE.child("Users")
    fileprivate var _REF_POSTS = DB_BASE.child("Scanned")
    
    // MARK: - Setters
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let UID = FIRAuth.auth()?.currentUser?.uid
        let USER = REF_USERS.child(UID!)
        
        return USER
    }
    
    // MARK: - User Creation
    func createFIRDBUser(_ uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
