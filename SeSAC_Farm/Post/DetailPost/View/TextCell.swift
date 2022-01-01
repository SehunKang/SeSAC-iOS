//
//  TextCell.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/02.
//

import Foundation
import UIKit
import SnapKit

class TextCell: UITableViewCell {
    
    static let identifier = "TextCell"
    
    let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainTextLabel)
        mainTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide).offset(-60)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
