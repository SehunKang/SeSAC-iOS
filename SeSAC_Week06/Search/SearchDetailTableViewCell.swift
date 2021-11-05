//
//  SearchDetailTableViewCell.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/05.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {

	
	static let identifier = "SearchDetailTableViewCell"
	
	@IBOutlet weak var detailImageView: UIImageView!
	@IBOutlet weak var detailDateButton: UIButton!
	@IBOutlet weak var detailTextVuew: UITextView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

