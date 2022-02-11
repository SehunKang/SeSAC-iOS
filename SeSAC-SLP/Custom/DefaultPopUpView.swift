//
//  DefaultPopUpView.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/12.
//

import UIKit
import SnapKit

class DefaultPopUpView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Body1_M16.font
        label.textColor = CustomColor.SLPBlack.color
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Title4_R14.font
        label.textColor = CustomColor.SLPGray7.color
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.SLPGray2.color
        button.setTitleColor(CustomColor.SLPBlack.color, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.SLPGreen.color
        button.setTitleColor(CustomColor.SLPWhite.color, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        [titleLabel, subTitleLabel, cancelButton, okButton].forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.trailing.equalTo(okButton.snp.leading).inset(8)
        }
        
        okButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
        }
        
    }

}
