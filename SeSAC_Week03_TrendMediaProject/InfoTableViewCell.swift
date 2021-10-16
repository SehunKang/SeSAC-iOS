//
//  InfoTableViewCell.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/16.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

	
	@IBOutlet weak var infoImage: UIImageView!
	@IBOutlet weak var infoTitle: UILabel!
	@IBOutlet weak var infoRealeaseDate: UILabel!
	@IBOutlet weak var infoSynopsis: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
