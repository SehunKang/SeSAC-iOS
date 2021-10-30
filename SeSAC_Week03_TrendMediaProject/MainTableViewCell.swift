//
//  MainTableViewCell.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit

class MainTableViewCell: UITableViewCell {

	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var expectationLabel: UILabel!
	@IBOutlet weak var rateLabel: UILabel!
	@IBOutlet weak var movieNameLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var alikeContentsRecommendView: UIView!
	@IBOutlet weak var alikeContentsRecommendButton: UIButton!
	@IBOutlet weak var alikeContentsRecommendLabel: UILabel!
	@IBOutlet weak var webViewButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	

}
