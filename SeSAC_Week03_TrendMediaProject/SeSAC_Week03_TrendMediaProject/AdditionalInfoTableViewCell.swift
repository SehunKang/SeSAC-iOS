//
//  AdditionalInfoTableViewCell.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/19.
//

import UIKit

class AdditionalInfoTableViewCell: UITableViewCell {

	@IBOutlet weak var additionalInfoLabel: UILabel!
	@IBOutlet weak var additionalInfoButton: UIButton!
	@IBOutlet weak var additionalInfoView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
