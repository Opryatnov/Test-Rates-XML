//
//  ViewControllerTableViewCell.swift
//  RatesTestProject
//
//  Created by Dmitriy Opryatnov on 2/10/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import UIKit
import MobileCoreServices
class CustomTableViewCell: UITableViewCell {
	
	@IBOutlet weak var charCodeLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}

extension CustomTableViewCell: UITableViewDelegate {
	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print("did select raw at indexPath: \(indexPath)")
//	}
}
