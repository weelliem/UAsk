//
//  CreateUserViewController.swift
//  UAsk
//
//  Created by William Hong on 22/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the viewing answers sceen/page. 
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct cellAnswerData {
    let answerTxt: String?
}

// this is the private answer viewcontroller that also contains a tableview since this tableview in contained in a viewconroller there is no need for a table viewcontroller
class MyAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myQuestionContent: UILabel!
    @IBOutlet weak var myQuestionsName: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    var arrayOfData: [cellAnswerData] = [] //cell contains all the data that is pulled from firebase
    let db = Firestore.firestore()
    var uId: String?
    let tableView = UITableView() //allows for the reference to the table view
    
    //dismisses the current view and returns to the last view
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //counts the array to check how many rows of data there is
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    //this function populates each respective row with its specific data group
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //this links the row or cell to the specific custom cell xib file
        let cell = Bundle.main.loadNibNamed("MyAnswersTableViewCell", owner: self, options: nil)?.first as! MyAnswersTableViewCell
        
        cell.selectionStyle = .none
        cell.answerTestLabel.text = arrayOfData[indexPath.row].answerTxt
        
        return cell
    }
    
    //this function sets the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 78
    }
    
    //this function handles what happens when the cell is selected note you can specify each respective cell to different transitions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : String
        
        // add different cases to add unique view transition
        switch indexPath.row {
        default:
            viewController = "AnswersViewController"
        }
        
        //this code initiates the transition to the other views
        let privateAnswersViewController = storyboard.instantiateViewController(withIdentifier: viewController)
        
        self.present(privateAnswersViewController, animated:true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArray()
        loadData()
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // this function loads the data from firestore and sets the objects on the view
    func loadData() {
        //database query to call for data
        db.collection("questions").document(uId!).getDocument()
            { (QuerySnapshot, err) in
                if err != nil{
                    print("Error getting documents: \(String(describing: err))");
                } else {
                        let document = QuerySnapshot
                        let data = document!.data()
                    
                        //sets the data fetched to respective variables
                        let data2 = data!["questionTxt"] as? String
                        let data3 = data!["name"]as? String
                    
                        //sets the data to respective objects
                        self.myQuestionContent.text = data2
                        self.myQuestionsName.text = data3
                }
            }
    }
    
    //this function populates the tableview with data with database query calls to firestore
    func createArray() {
        var tempTxt: [cellAnswerData] = []

        db.collection("questions").document(uId!).collection("answers").getDocuments
            { (QuerySnapshot, err) in
                if err != nil {
                    print("Error getting documents: \(String(describing: err))");
                } else {
                    for document in QuerySnapshot!.documents {
                        self.arrayOfData.removeAll()
                        let data = document.data()
                        
                        let data1 = data["answerTxt"] as? String
   
                        let txt = cellAnswerData(answerTxt: data1!)
                        
                        tempTxt.append(txt)
                    }
                    
                    self.arrayOfData = tempTxt
                    
                    //this call is important since it allows the table to be updated thus allowing the table to display data 
                    DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                }
        }
    }
}
