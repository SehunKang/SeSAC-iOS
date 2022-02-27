//
//  SignUpCheckView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class SignUpCheckView: UIView {
    
    let askLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.text = "이미 계정이 있나요?"
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        return label
    }()
    
    let signInButton: UIButton = {
       let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(askLabel)
        self.addSubview(signInButton)
        
        askLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.leading.equalTo(askLabel.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

