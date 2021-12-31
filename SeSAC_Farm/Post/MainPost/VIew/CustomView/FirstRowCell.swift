//
//  FirstRowCell.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class FirstRowCell: UITableViewCell {
    
    static let identifier = "FirstRowCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.sizeToFit()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [nameLabel, postLabel, dateLabel].forEach {
            self.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.lessThanOrEqualTo(safeAreaLayoutGuide).inset(20)
        }
        
        postLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(postLabel.snp.bottom).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-15)
            make.leading.trailing.equalTo(nameLabel)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
