//
//  MyQuestionsTableTableViewController.swift
//  UAsk
//
//  Created by William Hong on 29/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the my questions page/screen (is a
//  table view). 
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyQuestionsTableTableViewController: UITableViewController {
        
    var arrayOfData: [cellData] = []
    let currentUID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        createArray()
    }
    
    //this function populates the tableview with data with database query calls to firestore
    func createArray() {
        var tempTxt: [cellData] = []
        
        db.collection("questions").whereField("userId", isEqualTo: currentUID!).getDocuments()
            { (QuerySnapshot, err) in
                if err != nil {
                    print("Error getting documents: \(String(describing: err))");
                } else {
                    for document in QuerySnapshot!.documents {
                        self.arrayOfData.removeAll()
                        
                        let data = document.data()
                        let docId = document.documentID
    
                        let data1 = data["faculty"] as? String
                        let data2 = data["questionTxt"] as? String
                        let data3 = data["name"]as? String
                        let data4 = docId
                        
                        let txt = cellData(facTxt: data1!, quesTxt: data2!, nameTxt: data3!, docId: data4)
                        
                        tempTxt.append(txt)
                    }
                    self.arrayOfData = tempTxt

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
     //counts the array to check how many rows of data there is
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
     //this function populates each respective row with its specific data group
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("MyQuestionsTableViewCell", owner: self, options: nil)?.first as! MyQuestionsTableViewCell
       
        cell.selectionStyle = .none
        cell.myQuestionsContent.text = arrayOfData[indexPath.row].quesTxt
        cell.myQuestionLabel.text = arrayOfData[indexPath.row].facTxt
        cell.cellBackground.layer.cornerRadius = 20
        cell.cellBackground.clipsToBounds = true
        
        if (arrayOfData[indexPath.row].facTxt == "Engineering and IT") {
            cell.cellBackground.backgroundColor = UIColor.red
        }
        if (arrayOfData[indexPath.row].facTxt == "Arts and Social Sciences") {
            cell.cellBackground.backgroundColor = UIColor.orange
        }
        if (arrayOfData[indexPath.row].facTxt == "Design, Architecture and Building") {
            cell.cellBackground.backgroundColor = UIColor.brown
        }
        if (arrayOfData[indexPath.row].facTxt == "Law") {
            cell.cellBackground.backgroundColor = UIColor.purple
        }
        if (arrayOfData[indexPath.row].facTxt == "Business") {
            cell.cellBackground.backgroundColor = UIColor.blue
        }
        if (arrayOfData[indexPath.row].facTxt ==  "Science") {
            cell.cellBackground.backgroundColor = UIColor.magenta
        }
        if (arrayOfData[indexPath.row].facTxt ==  "Health") {
            cell.cellBackground.backgroundColor = UIColor.green
        }
        if (arrayOfData[indexPath.row].facTxt ==  "Trans-Disciplinary Innovation") {
            cell.cellBackground.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
     //this function sets the height of the cell or the row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
    
    //this function determains what happens when the specified row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : String
        switch indexPath.row {
            
        default:
            viewController = "MyAnswersViewController"
        }
        
        if let privateAnswersViewController = storyboard.instantiateViewController(withIdentifier: viewController) as? MyAnswersViewController {
            
            privateAnswersViewController.uId = arrayOfData[indexPath.row].docId
            self.present(privateAnswersViewController, animated:true, completion: nil)
        }
    }
}
