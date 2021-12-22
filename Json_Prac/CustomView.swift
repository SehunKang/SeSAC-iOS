//
//  CustomStackView.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/22.
//

import Foundation
import UIKit

class CustomView: UIView {
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share BEER", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [refreshButton, shareButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        refreshButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(refreshButton.snp.height)
        }
        shareButton.snp.makeConstraints { make in
            make.leading.equalTo(refreshButton.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
