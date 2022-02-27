//
//  SignUpView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit

class SignUpView: UIView {
    
    let signUpField = SignUpFieldView()
    
    let validateLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 다릅니다."
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(signUpField)
        
        signUpField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
        }
        self.addSubview(validateLabel)
        validateLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpField.snp.bottom).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

