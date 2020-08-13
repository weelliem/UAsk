//
//  ViewController.swift
//  UAsk
//
//  Created by Megan Farleigh on 22/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the Login Page/Screen
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailEditTxt: UITextField!
    @IBOutlet weak var passEditTxt: UITextField!
    @IBOutlet weak var loginErrorTxt: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    // Button for signing in user
    @IBAction func buttonLogin(_ sender: Any) {
        checkFieldValues()
        signIn()
    }
    
    // Button for creating account. Takes user to the
    // create account page.
    @IBAction func buttonCreate(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountTransition", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get firebase auth state
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    // Checks the values of the username and password field to ensure
    // values have been inputted by user.
    func checkFieldValues() -> Bool {
        guard let email = emailEditTxt.text, !email.isEmpty else {
            loginErrorTxt.text = "Please input email. "
            loginErrorTxt.isHidden = false
            return false
        }
        
        guard let password = passEditTxt.text, !password.isEmpty else {
            loginErrorTxt.text = "Please input password."
            loginErrorTxt.isHidden = false
            return false
        }
        return true
    }
    
    // Checks the credentials of the user with Firebase Authentication
    // and lets user know if details are incorrect.
    func signIn() {
        guard
            let email = emailEditTxt.text,
            let password = passEditTxt.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        // Firebase Authentication to sign in user
        Auth.auth().signIn(withEmail: email,
                           password: password) { (user, error) in
                            if let _ = error, user == nil {
                                print("Not athenticated")
                                self.loginErrorTxt.text = "Invalid email and/or password."
                                self.loginErrorTxt.isHidden = false
                                return
                            }
                            
                            // Takes user to AskQuestion page if sign in was
                            // successful. 
                            self.performSegue(withIdentifier: "QuestionTransition", sender: self)
        }
    }
}

