//
//  RatesCellTableViewCell.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/9/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import UIKit

class RatesCellTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


