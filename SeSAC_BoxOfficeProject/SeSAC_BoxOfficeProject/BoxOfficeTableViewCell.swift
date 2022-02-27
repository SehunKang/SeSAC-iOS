//
//  BoxOfficeTableViewCell.swift
//  SeSAC_BoxOfficeProject
//
//  Created by Sehun Kang on 2021/10/29.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {
	
	let identifier = "BoxOfficeTableViewCell"

	@IBOutlet weak var rankLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		rankLabel.backgroundColor = .orange
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
