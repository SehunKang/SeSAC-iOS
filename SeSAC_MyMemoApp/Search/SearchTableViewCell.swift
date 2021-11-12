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
		self.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
		searchTitle.textColor = .white
		searchDate.font = .systemFont(ofSize: 15)
		searchDate.textColor = .gray
		searchText.font = .systemFont(ofSize: 15)
		searchText.textColor = .gray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
