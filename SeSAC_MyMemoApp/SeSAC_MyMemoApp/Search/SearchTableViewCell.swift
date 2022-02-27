//
//  SearchTableViewCell.swift
//  SeSAC_MyMemoApp
//
//  Created by Sehun Kang on 2021/11/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

	static let identifier = "SearchTableViewCell"
	
	@IBOutlet weak var searchTitle: UILabel!
	@IBOutlet weak var searchDate: UILabel!
	@IBOutlet weak var searchText: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		searchTitle.textColor = .label
		searchTitle.font = .boldSystemFont(ofSize: 17)
		searchDate.font = .systemFont(ofSize: 15)
		searchDate.textColor = .secondaryLabel
		searchText.font = .systemFont(ofSize: 15)
		searchText.textColor = .secondaryLabel
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
