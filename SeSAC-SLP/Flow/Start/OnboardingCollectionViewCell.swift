//
//  OnboardingCollectionViewCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/26.
//

import UIKit
import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCollectionViewCell"
    
    let imageView = UIImageView()
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("onboarding cell error")
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
