//
//  MyQuestionsTableViewCell.swift
//  UAsk
//
//  Created by William Hong on 29/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the tabe cells in the my questions
//  page/screen. 
//

import UIKit

//this class connects the tableview to the cell and the xib file to allow for custom cells
class MyQuestionsTableViewCell: UITableViewCell {

 
    @IBOutlet weak var myQuestionLabel: UILabel!
    @IBOutlet weak var myQuestionsContent: UILabel!
    @IBOutlet weak var cellBackground: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
