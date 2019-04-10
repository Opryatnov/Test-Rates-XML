//
//  DetailsTableViewCell.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/15/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
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
