//
//  StartButtonView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import UIKit
import SnapKit

class StartButtonView: UIView {
    
    let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("시작하기", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        self.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
