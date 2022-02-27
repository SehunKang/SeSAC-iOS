//
//  SignInView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit
import SimpleCheckbox

class SignInView: UIView {
    
    let checkBox: Checkbox = {
        let checkBox = Checkbox()
        checkBox.checkedBorderColor = .systemGreen
        checkBox.uncheckedBorderColor = .lightGray
        checkBox.borderStyle = .square
        checkBox.checkmarkColor = .systemGreen
        checkBox.checkmarkStyle = .tick
        return checkBox
    }()
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디와 비밀번호 기억하기"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let signInField = SignUpFieldView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        fieldConfig()
        checkConfig()
    }
    
    func fieldConfig() {
        
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
        signInField.nickNameField.isHidden = true
        signInField.passwordCheck.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        signInField.passwordCheck.isHidden = true
        signInField.confirmButton.setTitle("로그인", for: .normal)

    }
    
    func checkConfig() {
        
        self.addSubview(checkLabel)
        self.addSubview(checkBox)

        checkBox.snp.makeConstraints { make in
            make.trailing.equalTo(signInField.confirmButton.snp.trailing)
            make.top.equalTo(signInField.confirmButton.snp.bottom).offset(10)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        checkLabel.snp.makeConstraints { make in
            make.trailing.equalTo(checkBox.snp.leading).offset(-10)
            make.centerY.equalTo(checkBox)
            make.height.equalTo(30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

