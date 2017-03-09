//
//  RegisterDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 02/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

enum AuthType {
    case logIn, signUp
}

protocol AuthManagerDelegate: class {
    
    func authManager(_ authManager: AuthManager, wasAuthorised auth: Bool, with error: Error?, for type: AuthType)
    
}

class AuthManager: NSObject {
    
    /** Delegate */
    weak var delegate: AuthManagerDelegate?
    
    /** uid */
    static var uid: String?
    
    /** uid */
    internal(set) var uid: String?
    
    override init() { }
    
}

extension AuthManager {

    /** Sign out function */
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
    
    /** Delegate */
    static func isLoggedIn() -> Bool {
        guard let user = FIRAuth.auth()?.currentUser else { return false }
        self.uid = user.uid
        
        return true
    }
    
}

/** Extension */
extension AuthManager {

    /** Delegate */
    func logIn(withEmail email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.delegate?.authManager(self, wasAuthorised: false, with: error, for: .logIn)
                return
            }
            
            guard let user = user else {
                self.delegate?.authManager(self, wasAuthorised: false, with: AMError.guardFail(#function, (#line - 1)), for: .logIn)
                return
            }
            
            let userData: Dictionary<String, String> = [
                "provider" : user.providerID,
                "email" : user.email!
            ]
            
            Analytics.logLogin()
            
            self.completeCreate(user: user, withUserData: userData)
            self.delegate?.authManager(self, wasAuthorised: true, with: nil, for: .logIn)
            return
        })
    }
    
    /** Delegate */
    func signUp(withEmail email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.delegate?.authManager(self, wasAuthorised: false, with: error, for: .signUp)
                return
            }
            
            guard let user = user else {
                self.delegate?.authManager(self, wasAuthorised: false, with: AMError.guardFail(#function, #line), for: .signUp)
                return
            }
            
            let userData: Dictionary<String, String> = [
                "provider" : user.providerID,
                "email" : user.email!
            ]
            
            Analytics.logSignUp()
            
            self.completeCreate(user: user, withUserData: userData)
            self.delegate?.authManager(self, wasAuthorised: true, with: nil, for: .signUp)
            return
        })
    }
    
    /** Delegate */
    func signUp(withEmail email: String, password: String, userData: Dictionary<String, String>) {
        //
    }
    
}

private extension AuthManager {

    /** Delegate */
    func completeCreate(user: FIRUser, withUserData userData: Dictionary<String, String>) {
        self.uid = user.uid
        DataService.Singleton.createFIRDBUser(user.uid, userData: userData)
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
