//
//  CastInfoTableViewCell.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/16.
//

import UIKit

class CastInfoTableViewCell: UITableViewCell {

	@IBOutlet weak var castImage: UIImageView!
	@IBOutlet weak var actorLabel: UILabel!
	@IBOutlet weak var castLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
