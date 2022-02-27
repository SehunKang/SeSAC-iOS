//
//  SignUpView.swift
//  SeSAC_Week14
//
//  Created by Sehun Kang on 2021/12/27.
//

import Foundation
import UIKit
import SnapKit

class SignUpView: UIView, ViewRepresentable {
    
    let usernameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemOrange
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        
        [usernameTextField, passwordTextField, emailTextField].forEach {
            self.addSubview($0)
            $0.backgroundColor = .white
        }
        self.addSubview(signUpButton)
        usernameTextField.placeholder = "Name"
        passwordTextField.placeholder = "Password"
        emailTextField.placeholder = "email"
    }
    
    func setupConstraints() {
        
        usernameTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

    }
    
}
