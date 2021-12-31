//
//  SignInView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit

class SignInView: UIView {
    
    let signInField = SignUpFieldView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(signInField)
        signInField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()

        }
        
        signInField.nickNameField.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        signInField.passwordCheck.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        
        signInField.confirmButton.setTitle("로그인", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

