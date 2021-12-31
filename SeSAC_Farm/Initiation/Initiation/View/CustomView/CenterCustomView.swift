//
//  CenterView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit

class CenterCustomView: UIView {
    
    let logoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.sizeToFit()
        label.textAlignment = .center
        label.text = "mainLabel"
        return label
    }()
    
    let additionalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .center
        label.text = "additionalLabel"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(logoImage)
        self.addSubview(mainLabel)
        self.addSubview(additionalLabel)
        
        logoImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(mainLabel.snp.top)
            make.width.equalTo(150)
            make.height.equalTo(logoImage.snp.width)
            make.centerX.equalToSuperview()
        }
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        additionalLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
}
