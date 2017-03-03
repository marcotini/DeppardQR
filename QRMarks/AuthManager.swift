//
//  RegisterDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 02/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

protocol AuthManagerDelegate: class {
    
    func authManager(wasAuthorised auth: Bool, with error: Error?)
    
}

class AuthManager {
    
    weak var delegate: AuthManagerDelegate?
    
    static var uid: String?
    
    init() { }
    
}

extension AuthManager {

    static func signOut(_ completion: ((Error?) -> Void)? = nil) {
        do {
            try FIRAuth.auth()?.signOut()
            if completion != nil {
                completion!(nil)
            }
        } catch {
            if completion != nil {
                completion!(error)
            }
        }
    }
    
    static func isLoggedIn() -> Bool {
        guard let user = FIRAuth.auth()?.currentUser else { return false }
        self.uid = user.uid
        
        return true
    }
    
}

//FIRAuth

extension AuthManager {

    func login(withEmail email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.delegate?.authManager(wasAuthorised: false, with: error)
                return
            }
            
            guard let user = user else {
                self.delegate?.authManager(wasAuthorised: false,
                                           with: AMError.guardFail(#function, #line))
                return
            }
            
            let userData: Dictionary<String, String> = [
                "provider" : user.providerID,
                "email" : user.email!
            ]
            
            self.completeCreateUser(user.uid, withUserData: userData)
            Analytics.logLogin()
            self.delegate?.authManager(wasAuthorised: true, with: nil)
            return
        })
    }
    
    func signUp(withEmail email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.delegate?.authManager(wasAuthorised: false, with: error)
                return
            }
            
            guard let user = user else {
                self.delegate?.authManager(wasAuthorised: false,
                                           with: AMError.guardFail(#function, #line))
                return
            }
            
            let userData: Dictionary<String, String> = [
                "provider" : user.providerID,
                "email" : user.email!
            ]
            
            self.completeCreateUser(user.uid, withUserData: userData)
            Analytics.logSignUp()
            self.delegate?.authManager(wasAuthorised: true, with: nil)
            return
        })
    }
    
    func signUp(withEmail email: String, password: String, extraData: Dictionary<String, String>) {
        //
    }
    
    private func completeCreateUser(_ uid: String, withUserData userData: Dictionary<String, String>) {
        DataService.Singleton.createFIRDBUser(uid, userData: userData)
    }
}

/**
 Custom errors for when issues happen after the code passes:
 
        if error != nil
 
 Inside the `FIRAuth.auth()` function calls
 */
enum AMError: Error {
    case guardFail(String, Int)
}

extension AMError: CustomDebugStringConvertible {
    
    var debugDescription: String {
        switch self {
        case .guardFail: return "guardFail(,)"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .guardFail(let function, let line):
            return "guard statement failed at \(function) on line: \(line)"
        }
    }
}
