//
//  CollectionViewCell.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

	static let identifier = "CollectionViewCell"
	
	@IBOutlet weak var bookView: UIView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var rate: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
