//
//  AdditionalDiscriptionView.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/21.
//

import Foundation
import UIKit

class AdditionalDiscriptionView: UIView {
    
    static let identifier = "AdditionalDiscriptionView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Food - Paring"
        label.font = .boldSystemFont(ofSize: 33)
        label.sizeToFit()
        return label
    }()
    
    let paringLabel: UILabel = {
        let label = UILabel()
        label.text = "asdfasdfasda"
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "asdfklnasdakl;sdnflkasndflkasndflkasndfklansdflkasdnflkasdnflk"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, paringLabel, explanationLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        setLayOut()
        
    }
    
    func setLayOut() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        paringLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.lessThanOrEqualTo(300)
            make.centerX.equalToSuperview()
        }
        explanationLabel.snp.makeConstraints { make in
//            make.top.equalTo(paringLabel.snp.bottom).offset(50)
            make.width.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
        
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
