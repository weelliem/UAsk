//
//  ViewQuestionsTableTableViewCell.swift
//  UAsk
//
//  Created by William Hong on 27/5/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the tabe cells in the View questions
//  page/screen
//

import UIKit

//this class connects the tableview to the cell and the xib file to allow for custom cells 
class ViewQuestionsTableTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabelTest: UILabel!
    @IBOutlet weak var cellLabelContent: UILabel!
    @IBOutlet weak var cardView: UIImageView!
    @IBOutlet weak var nameChip: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
