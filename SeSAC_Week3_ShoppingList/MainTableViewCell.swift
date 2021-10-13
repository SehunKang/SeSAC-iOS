//
//  MainTableViewCell.swift
//  SeSAC_Week3_ShoppingList
//
//  Created by Sehun Kang on 2021/10/13.
//

import UIKit

class MainTableViewCell: UITableViewCell {

	
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var toDoLabel: UILabel!
	@IBOutlet weak var starButton: UIButton!
	@IBOutlet weak var viewForCell: UIView!
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
