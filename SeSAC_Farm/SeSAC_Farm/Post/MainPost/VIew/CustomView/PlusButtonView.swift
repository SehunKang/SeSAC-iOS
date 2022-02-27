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
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(plusImage)
        plusImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        self.backgroundColor = .systemGreen

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

