//
//  QuestionViewController.swift
//  UAsk
//
//  Created by William Hong on 22/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the scroll view (the base view for
//  View questions, ask questions, my questions
//

import UIKit
import FirebaseAuth

/* this conroller handles instances of different controllers to allow for swipe navagation */
class ScrollViewController: UIViewController {
    
    
    @IBOutlet weak var fragment: UIScrollView!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    // this fuction runs when the view is loaded
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // these variables allows the classes to link to the xib coco class viewcontrollers
        let viewQuestionsTableViewController : ViewQuestionsTableViewController = ViewQuestionsTableViewController(nibName: "ViewQuestionsTableViewController", bundle: nil)
        let myQuestionsTableTableViewController : MyQuestionsTableTableViewController = MyQuestionsTableTableViewController(nibName: "MyQuestionsTableTableViewController", bundle: nil)
        let askQuestionViewController : AskQuestionViewController = AskQuestionViewController(nibName: "AskQuestionViewController", bundle: nil)
        
        //adds the view to the scrollview
        self.addChild(askQuestionViewController)
        self.fragment.addSubview(askQuestionViewController.view)
        askQuestionViewController.didMove(toParent: self)
        
        self.addChild(viewQuestionsTableViewController)
        self.fragment.addSubview(viewQuestionsTableViewController.view)
        viewQuestionsTableViewController.didMove(toParent: self)
        
        self.addChild(myQuestionsTableTableViewController)
        self.fragment.addSubview(myQuestionsTableTableViewController.view)
        myQuestionsTableTableViewController.didMove(toParent: self)
        
        // sets the size of each view
        var viewQuestionsTableViewControllerFragment : CGRect = viewQuestionsTableViewController.view.frame
        viewQuestionsTableViewControllerFragment.origin.x = self.view.frame.width
        viewQuestionsTableViewController.view.frame = viewQuestionsTableViewControllerFragment
        
        var myQuestionsTableTableViewControllerFragment : CGRect = myQuestionsTableTableViewController.view.frame
        myQuestionsTableTableViewControllerFragment.origin.x = 2 * self.view.frame.width
        myQuestionsTableTableViewController.view.frame = myQuestionsTableTableViewControllerFragment
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
        
        self.fragment.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.size.height)
        
    }
    
    // this fuction allows the use to sign out of firestore database and navagate back to the main screen
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
}
    
