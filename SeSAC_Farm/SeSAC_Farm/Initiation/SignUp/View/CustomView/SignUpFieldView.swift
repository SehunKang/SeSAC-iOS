//
//  SignUpFieldView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class SignUpFieldView: UIView {
    
    let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "이메일 주소"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let nickNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "닉네임"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    let passwordCheck: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호 확인"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .systemGreen
//        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [emailField, nickNameField, passwordField, passwordCheck, confirmButton].forEach {
            self.addSubview($0)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        nickNameField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(nickNameField.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        passwordCheck.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(passwordCheck.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

