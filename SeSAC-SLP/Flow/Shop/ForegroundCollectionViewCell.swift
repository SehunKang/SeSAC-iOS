//
//  ForegroundCollectionViewCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import UIKit
import SnapKit

class ForegroundCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = CustomColor.SLPGray2.color.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Title2_R16.font
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.titleLabel?.font = CustomFont.Title5_M12.font
        return button
    }()
    
    let discriptionLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Body3_R14.font
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("foregroundcell not implemented")
    }
    
    private func configure() {
        [imageView, nameLabel, priceButton, discriptionLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        discriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(priceButton.snp.bottom).offset(8)
        }
    }
}
