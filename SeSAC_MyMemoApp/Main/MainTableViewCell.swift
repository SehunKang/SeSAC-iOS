//
//  MainTableViewCell.swift
//  SeSAC_MyMemoApp
//
//  Created by Sehun Kang on 2021/11/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

	static let identifier = "MainTableViewCell"
	
	@IBOutlet weak var titleMemo: UILabel!
	@IBOutlet weak var dateMemo: UILabel!
	@IBOutlet weak var textMemo: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		titleMemo.textColor = .label
		titleMemo.font = .boldSystemFont(ofSize: 17)
		dateMemo.textColor = .secondaryLabel
		dateMemo.font = .systemFont(ofSize: 15)
		textMemo.textColor = .secondaryLabel
		textMemo.font = .systemFont(ofSize: 15)
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
