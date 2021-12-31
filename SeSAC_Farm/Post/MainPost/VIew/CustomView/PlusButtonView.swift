//
//  PlusButtonView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit

class PlustButtonVIew: UIControl {
    
    let plusImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus")
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(plusImage)
        plusImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        self.backgroundColor = .systemGreen
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width/2

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

