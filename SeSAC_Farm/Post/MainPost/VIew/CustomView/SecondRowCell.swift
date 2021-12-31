//
//  SecondRowCell.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class SecondRowCell: UITableViewCell {
    
    static let identifier = "SecondRowCell"

    
    let bubbleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bubble.right")
        return imageView
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [bubbleImage, commentLabel].forEach {
            self.addSubview($0)
        }
        
        bubbleImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.equalTo(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(bubbleImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
