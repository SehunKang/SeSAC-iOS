//
//  MyHobbyCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/06.
//

import UIKit
import SnapKit

class MyHobbyCell: UICollectionViewCell {
    
    static let reuseIdentifier = "My-Hobby-Cell"
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.SLPGreen.color
        label.font = CustomFont.Title4_R14.font
        label.sizeToFit()
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "close_small")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = CustomColor.SLPGreen.color
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("custom cell not implemented")
    }
    
    func configure() {
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(5)
            make.trailing.equalTo(imageView.snp.leading).offset(-8)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
    }
}
