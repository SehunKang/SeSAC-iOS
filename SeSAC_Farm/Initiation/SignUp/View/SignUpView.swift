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
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

