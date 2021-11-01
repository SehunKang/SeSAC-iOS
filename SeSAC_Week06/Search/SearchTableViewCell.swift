//
//  SearchTableViewCell.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/01.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
	
	static let identifier = "SearchTableViewCell"

	@IBOutlet weak var cellTitleLabel: UILabel!
	@IBOutlet weak var cellDateLabel: UILabel!
	@IBOutlet weak var cellTextLabel: UILabel!
	@IBOutlet weak var cellImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
