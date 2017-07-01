//
//  Step2CustomCell.swift
//  ToDo App
//
//  Created by Phontaine Judd on 6/26/17.
//  Copyright © 2017 Echessa. All rights reserved.
//

import UIKit

class Step2CustomCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
