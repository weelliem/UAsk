//
//  MyAnswersTableViewCell.swift
//  UAsk
//
//  Created by William Hong on 3/6/19.
//  Copyright © 2019 Megan Farleigh. All rights reserved.
//  View Controller for the my answers table view cell. 
//

import UIKit

//this class connects the tableview to the cell and the xib file to allow for custom cells 
class MyAnswersTableViewCell: UITableViewCell {

    @IBOutlet weak var answerTestLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
