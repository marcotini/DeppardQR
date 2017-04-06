//
//  RegisterDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 02/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

@objc enum AuthType: Int {
    case logIn, signUp
    
    var name: String {
        switch self {
        case .logIn : return "Loggin In"
        case .signUp : return "Signing Up"
        }
    }
    
}

@objc protocol AuthManagerDelegate: class {
    
    /// Delegate method to be called when the Auth Manager authorises the log in / sign up
    ///
    /// - Parameters:
    ///   - authManager: The AuthManager object
    ///   - type: The authentication type, check the `AuthType` enum
    @objc func authManager(_ authManager: AuthManager, wasAuthorisedForType type: AuthType)
    
    /// Delegate method to be called when authoristion fails, doesn't need to be handled.
    ///
    /// - Parameters:
    ///   - authManager: The AuthManager object
    ///   - error: The error for why the auth failed
    ///   - type: The authentication type, check the `AuthType` enum
    @objc optional func authManager(_ authManager: AuthManager, didFailWithError error: Error, for type: AuthType)
    
}

@objc class AuthManager: NSObject {
    
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
                self.delegate?.authManager?(self, didFailWithError: error!, for: .logIn)
                return
            }
            
            guard let user = user else {
                self.delegate?.authManager?(self,
                                            didFailWithError: AMError(withType: .guardFail),
                                            for: .logIn)
                return
            }
            
            let userData: Dictionary<String, String> = [
                "provider" : user.providerID,
                "email" : user.email!
            ]
            
            Analytics.logLogin()
            
            self.completeCreate(user: user, withUserData: userData)
            self.delegate?.authManager(self, wasAuthorisedForType: .logIn)
            return
        })
    }
    
    /** Delegate */
    func signUp(withEmail email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.delegate?.authManager?(self, didFailWithError: error!, for: .signUp)
                return
            }
            
            guard let user = user else {
                self.delegate?.authManager?(self,
                                            didFailWithError: AMError(withType: .guardFail),
                                            for: .signUp)
                return
            }
            
            let userData: Dictionary<String, String> = [
                "provider" : user.providerID,
                "email" : user.email!
            ]
            
            Analytics.logSignUp()
            
            self.completeCreate(user: user, withUserData: userData)
            self.delegate?.authManager(self, wasAuthorisedForType: .signUp)
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

