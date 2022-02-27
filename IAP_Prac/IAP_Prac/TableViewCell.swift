//
//  TableViewCell.swift
//  IAP_Prac
//
//  Created by Sehun Kang on 2022/01/09.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
