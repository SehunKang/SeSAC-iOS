//
//  BackgroundCollectionViewCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/23.
//

import UIKit
import SnapKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Title2_R16.font
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.titleLabel?.font = CustomFont.Title5_M12.font
        return button
    }()
    
    let discriptionLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Body3_R14.font
        label.numberOfLines = 0
        return label
    }()
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("foregroundcell not implemented")
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(containerView)
        [nameLabel, priceButton, discriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview()
        }
        discriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
            make.top.equalTo(priceButton.snp.bottom).offset(8)
        }
    }

}
