//
//  AskQuestionViewController.swift
//  UAsk
//
//  Created by William Hong on 29/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the ask questions page/screen. 
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AskQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    @IBOutlet weak var errorTxt: UILabel!
    @IBOutlet weak var questionTxt: UITextView!
    @IBOutlet weak var facultyPicker: UIPickerView!
    @IBOutlet weak var submitQButton: UIButton!
    @IBOutlet weak var successfulTxt: UILabel!
    
    var facultyData = ["Faculty","Engineering and IT", "Arts and Social Sciences", "Design, Architecture and Building", "Law", "Business", "Science", "Health", "Trans-Disciplinary Innovation"]
    
    var uid = ""
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTxt.layer.cornerRadius = 15
        questionTxt.clipsToBounds = true
        
        self.facultyPicker.dataSource = self
        self.facultyPicker.delegate = self
        
        // Set up Firebase Auth
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
        
        // Firestore setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        getUserData()
    }

    // Sign out user when button is pressed. The user is
    // taken back to the sign-in screen.
    @IBAction func signOutBtn(_ sender: Any) {
        do {
            // Sign's out with Firebase Auth
            try Auth.auth().signOut()
        } catch {
            print("Auth error")
        }
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController : String
            viewController = "LoginViewController"
            
            if let loginViewController = storyboard.instantiateViewController(withIdentifier: viewController) as? LoginViewController {
                self.present(loginViewController, animated:true, completion: nil)
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
    
    // Button click when the user wishes to submit a question.
    @IBAction func submitQuestion(_ sender: Any) {
        if (checkFieldValues()) {
            addQuestionToDb()
            clearField()
            showSuccessTxt()
        }
    }
    
    // Checks the  values of the UI fields to ensure they have
    // the correct values. If they do not, the user is
    // notified to input the correct values.
    func checkFieldValues() -> Bool {
        let selectedValue = facultyData[facultyPicker.selectedRow(inComponent: 0)]
        
        guard let question = questionTxt.text, !question.isEmpty else {
            errorTxt.isHidden = false
            return false
        }
        
        if (selectedValue == "Faculty") {
            errorTxt.text = "Please choose a faculty for the question"
            errorTxt.isHidden = false
            return false
        }
        
        errorTxt.isHidden = true
        return true
    }

    // Gets the current user's data from Firebase Auth and Firestore
    func getUserData() {
        // Firebase Auth
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
        }
        
        // Firestore
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let data = document?.data(), document?.exists ?? false {
                print(data["name"]!)
                self.username = data["name"] as! String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Adds question to the Firestore database
    func addQuestionToDb() {
        db.collection("questions").addDocument(data: [
            "faculty": facultyData[facultyPicker.selectedRow(inComponent: 0)],
            "questionTxt": questionTxt.text,
            "userId": uid,
            "name": username
            ])
    }
    
    // Clears all the UI fields to their default state.
    func clearField() {
        questionTxt.text.removeAll()
        facultyPicker.reloadAllComponents()
    }
    
    // Displays notification text of successful question submission
    func showSuccessTxt() {
        successfulTxt.isHidden = false
    }
}
