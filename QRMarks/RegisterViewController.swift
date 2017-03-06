//
//  RegisterViewController.swift
//  QRMarks
//
//  Created by Harry Wright on 02/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, AuthManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton! // This is used to change the action button
    @IBOutlet weak var actionButton: UIButton! // This is the button to call segue()
    
    private var _isLoggingIn: Bool = false
    private var authManager: AuthManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        secondPasswordTextField.delegate = self
        
        authManager = AuthManager()
        authManager?.delegate = self
        
    }
    
    // MARK: Actions
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        if _isLoggingIn {
            guard let email = emailTextField.text, !email.isEmpty else {
                print("emailTextField is empty")
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty else {
                print("passwordTextField is empty")
                return
            }
            
            if isAuthReady(_isLoggingIn) {
                authManager?.logIn(withEmail: email, password: password)
            } else {
                //
            }
        } else {
            guard let email = emailTextField.text, !email.isEmpty else {
                print("emailTextField is empty")
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty, password == secondPasswordTextField.text else {
                print("passwordTextField is empty or not equal to secondPasswordTextField")
                return
            }
            
            if isAuthReady(_isLoggingIn) {
                authManager?.signUp(withEmail: email, password: password)
            } else {
                //
            }
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if _isLoggingIn {
            setupAsSignUp()
        } else {
            setupAsLogIn()
        }
    }
    
    // MARK: UI Updates
    
    func setupAsLogIn() {
        self._isLoggingIn = !_isLoggingIn
        self.secondPasswordTextField.isHidden = true
        self.actionButton.setTitle("Sign In", for: .normal)
        self.signInButton.setTitle("Don't Have An Account? Sign Up.", for: .normal)
    }
    
    func setupAsSignUp() {
        self._isLoggingIn = !_isLoggingIn
        self.secondPasswordTextField.isHidden = false
        self.actionButton.setTitle("Sign Up", for: .normal)
        self.signInButton.setTitle("Already Have An Account? Sign In.", for: .normal)
    }
    
    // MARK: Clear Up
    func isAuthReady(_ loggingIn: Bool) -> Bool {
        if loggingIn {
            if ((emailTextField.text?.contains(String("@")))! && ((passwordTextField.text?.characters.count)! >= 6)) {
                return true
            }
            return false
        } else {
            if ((emailTextField.text?.contains(String("@")))! && ((passwordTextField.text?.characters.count)! >= 6) && (passwordTextField.text == secondPasswordTextField.text)) {
                return true
            }
            return false
        }
    }
    
    // MARK: AuthManagerDelegate
    
    func authManager(wasAuthorised auth: Bool, with error: Error?, _ type: AuthType) {
        if (!auth) || (error != nil) {
            self.alert(forError: error)
            return
        }
        
        if type == .logIn {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.alert()
        }
    }
}

/*
 MARK: - Alert Creation
 
 Extension to hold the alert creation functions
 */
extension RegisterViewController {
    
    func alert() {
        let alert = UIAlertController(title: "Welcome", message: "Would you like to use our scanner to try and record as much infomation from your buiness card or would you like to manually enter your details?", preferredStyle: .alert)
        let manual = UIAlertAction(title: "Manually", style: .default) { (nil) in
            //
        }
        
        let ocr = UIAlertAction(title: "Scanner", style: .default) { (nil) in
            //
        }
        
        let logOut = UIAlertAction(title: "log out", style: .destructive) { (nil) in
            AuthManager.signOut(nil)
        }
        
        alert.addAction(manual)
        alert.addAction(ocr)
        alert.addAction(logOut)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(forError error: Error?) {
        guard let message = error?.localizedDescription else { return }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let actions = setupAlertAction(withTitle: createAlertTitle(forError: error))
        for action in actions {
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    /// Sets up the display text for the error alerts
    ///
    /// - Parameter error: The function takes the error deterimins the designated `.default` title
    /// - Returns: The string title for the action title
    func createAlertTitle(forError error: Error?) -> String? {
        guard let message = error?.localizedDescription else { return nil }
        if message == "guardFail(,)" {
            Analytics.logError(by: nil, for: error)
        }
        
        print(message as Any)
        if errorMessage.contains(message) {
            return "Sign In"
        } else if signUpErrorMessage.contains(message) {
            return "Sign Up"
        }
        
        return "Back"
    }
    
    func setupAlertAction(withTitle title: String?) -> [UIAlertAction] {
        if title == "Sign In" {
            return [
                UIAlertAction(title: title, style: .default, handler: { (nil) in
                    self.setupAsLogIn()
                }),
                UIAlertAction(title: "Back", style: .default, handler: nil)
            ]
        } else if title == "Sign Up" {
            return [
                UIAlertAction(title: title, style: .default, handler: { (nil) in
                    self.setupAsSignUp()
                }),
                UIAlertAction(title: "Back", style: .default, handler: nil)
            ]
        } else {
            return [UIAlertAction(title: title, style: .default, handler: nil)]
        }
        
    }
}

/* 
 MARK: - UITextFieldDelegate
 */
extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailTextField {
            if let text = textField.text {
                if text.characters.count < 3 || !text.contains(String("@")) {
                    //
                }
            }
        } else if textField == passwordTextField {
            if let text = textField.text {
                if text.characters.count < 6 {
                    //
                }
            }
        } else if textField == secondPasswordTextField {
            if let text = textField.text {
                if text != passwordTextField.text {
                    //
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print(reason)
    }
}

let errorMessage = ["The email address is already in use by another account."]
let signUpErrorMessage = ["There is no user record corresponding to this identifier. The user may have been deleted."]
