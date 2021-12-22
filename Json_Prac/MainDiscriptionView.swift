//
//  CustomView.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/21.
//

import UIKit
import SnapKit

class MainDiscriptionView: UIView {
    
    static let identifier = "MainDiscriptionView"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.backgroundColor = .red
        label.text = "afdasdfasdfaasdfa"
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.backgroundColor = .orange
        label.text = "afdasdfasdfaasdfa"
        label.sizeToFit()
        return label
    }()
    
    let discriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.backgroundColor = .green
        label.text = "afdasdfasdfaasdfafjklqwneflkqwjnefkljqnwelfkjqnwlkefjnqlkwjefnjklqwenfkljqwenflkjqwenflkqjwnefklqjwnfahfljkdhfljkshflakjsdhflkajsdhflakjsdhflkajsdhflakjshdflajksdhflkajshdflkjahdflkjahskldfjahsdkljfahsldkfjahsdklfjahsdklfjhqlwejkfnqkljweblqkjewfbqlkejwqwenjrklnqwjkelrnqlkwejrnqlkwjernqlkwjernqlkwjernqklwjenrqlkwjenrlqkwjenrlkjw"
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.sizeToFit()
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setLayout()
    }
    
    
    func setLayout() {
        [nameLabel, companyLabel, discriptionLabel, moreButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.lessThanOrEqualTo(self.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.lessThanOrEqualTo(self.safeAreaLayoutGuide)
            make.height.equalTo(30)
            
        }
        
        discriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(moreButton.snp.top).offset(-10)
            make.width.lessThanOrEqualTo(self.safeAreaLayoutGuide)
        }
        
        moreButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
