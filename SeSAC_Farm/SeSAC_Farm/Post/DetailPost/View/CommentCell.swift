//
//  CommentCell.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    
    static let identifier = "CommentCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        [nameLabel, commentLabel, button].forEach {
            self.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(nameLabel)
            make.width.equalTo(30)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
            make.trailing.lessThanOrEqualTo(button.snp.leading).offset(-10)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
