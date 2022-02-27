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
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isSkeletonable = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Title2_R16.font
        label.isSkeletonable = true
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.titleLabel?.font = CustomFont.Title5_M12.font
        button.isSkeletonable = true
        return button
    }()
    
    let discriptionLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Body3_R14.font
        label.numberOfLines = 0
        label.isSkeletonable = true
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
        self.isSkeletonable = true
        containerView.isSkeletonable = true
        
        [nameLabel, priceButton, discriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(contentView.frame.width / 2)
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
        nameLabel.text = "하늘 공원"

        discriptionLabel.skeletonTextNumberOfLines = 2

    }

}
