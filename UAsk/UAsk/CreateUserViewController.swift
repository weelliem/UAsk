//
//  CreateUserViewController.swift
//  UAsk
//
//  Created by William Hong on 22/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the Create Account/User Page/Screen
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CreateUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    var email = ""
    var password = ""
    var facultyData = ["Faculty","Engineering and IT", "Arts and Social Sciences", "Design, Architecture and Building", "Law", "Business", "Science", "Health", "Trans-Disciplinary Innovation"]

    @IBOutlet weak var errorTxt: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var facultyPicker: UIPickerView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var password1Txt: UITextField!
    @IBOutlet weak var password2Txt: UITextField!
    
    // Back button to take user back to login screen.
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginTransition", sender: self)
    }
   
    // Called when the user selects the create account button
    // to create an account in Firebase
    @IBAction func createAccountButton(_ sender: Any) {
        if (checkFieldValues()) {
            createFirebaseAccount()
            
            // Calls login transition segue
            self.performSegue(withIdentifier: "LoginTransition", sender: self)
        } else {
            print("Failed")
        }
    }
    
    // Function for pickerView to return numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Function for pickerView which returns the total count
    // of the data stored in it.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return facultyData.count
    }
    
    // Function for pickerView for loading the data in the pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return facultyData[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up and initalise pickerView with data.
        facultyData = ["Faculty", "Engineering and IT", "Arts and Social Sciences", "Design, Architecture and Building", "Law", "Business", "Science", "Health", "Trans-Disciplinary Innovation"]
        self.facultyPicker.dataSource = self
        self.facultyPicker.delegate = self
        
        //  Firebase Auth set-up
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in 
        }
        
        // Firestore setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    // Checks the UI fields have the correct values, otherwise the
    // user will be notified to input the correct values.
    func checkFieldValues() -> Bool {
        guard let email = emailTxt.text, !email.isEmpty else {
            errorTxt.text = "Please use UTS student email."
            errorTxt.isHidden = false
            return false
        }
        
        guard let username = usernameTxt.text, !username.isEmpty else {
            errorTxt.text = "Please input a username."
            errorTxt.isHidden = false
            return false
        }
        
        guard let password1 = password1Txt.text, !password1.isEmpty else {
            errorTxt.text = "Please input a password."
            errorTxt.isHidden = false
            return false
        }
        
        guard let password2 = password2Txt.text, !password2.isEmpty else {
            errorTxt.text = "Please input a password."
            errorTxt.isHidden = false
            return false
        }
        
        if (!(email.contains("@student.uts.edu.au"))) {
            errorTxt.text = "Please use UTS student email."
            errorTxt.isHidden = false
            return false
        }
        
        let selectedValue = facultyData[facultyPicker.selectedRow(inComponent: 0)]
        
        if (selectedValue == "Faculty") {
            errorTxt.text = "Please select your faculty."
            errorTxt.isHidden = false
            return false
        }
        
        if (password1 != password2) {
            errorTxt.text = "Passwords do not match"
            errorTxt.isHidden = false
            return false
        }
        
        return true
    }

    // Creates account in Firebase Auth and Firestore
    func createFirebaseAccount() {
        guard let email = emailTxt.text, !email.isEmpty else {
            errorTxt.text = "An error occured, please try again later."
            errorTxt.isHidden = false
            print("Firebase Error")
            return
        }
        
        guard let password = password1Txt.text, !password.isEmpty else {
            errorTxt.text = "An erroroccured, please try again later;"
            errorTxt.isHidden = false
            print("Firebase error")
            return
        }
        
        
        // Creating account in Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let _ = error, authResult == nil {
                self.errorTxt.text = "An error occured, please try again later."
                self.errorTxt.isHidden = false
                print("Firebase error")
            } else {
                // Creates account in Firestore
                let uid = Auth.auth().currentUser?.uid
                self.db.collection("users").document(uid!).setData([
                    "name": self.usernameTxt.text!,
                    "faculty": self.facultyData[self.facultyPicker.selectedRow(inComponent: 0)],
                    "questions": [],
                    ])
               
            }
        }
        print("Firebase Successful")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clears Firebase auth state
        try! Auth.auth().signOut()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Clears Firebase auth state
        try! Auth.auth().signOut()
    }
    
}
