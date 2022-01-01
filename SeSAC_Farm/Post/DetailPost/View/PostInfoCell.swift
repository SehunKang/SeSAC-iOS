//
//  PostInfoCell.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation
import UIKit
import SnapKit

class PostInfoCell: UITableViewCell {
    
    static let identifier = "PostInfoCell"
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
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
        
        [profileImageView, nameLabel, dateLabel].forEach {
            self.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
//            make.bottom.equalTo(dateLabel.snp.top).offset(-5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
