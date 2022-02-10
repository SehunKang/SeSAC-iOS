//
//  BadgeView.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/10.
//

import UIKit
import SnapKit

class BadgeView: UICollectionReusableView {
    
    static let reuseIdentifier = "badge-element-kind"
    
    let badge = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        addSubview(badge)
        badge.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        badge.layer.cornerRadius = 8
        badge.clipsToBounds = true
    }
        
}
