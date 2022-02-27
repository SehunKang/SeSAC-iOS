//
//  MainTableViewCell.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/21.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    
    let secondView = AdditionalDiscriptionView()
    
//    let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        return stackView
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
//        stackView.addArrangedSubview(firstView)
//        stackView.addArrangedSubview(secondView)
//        self.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        stackView.snp.makeConstraints { make in
//            make.edges.equalTo(self)
//        }
        
        [secondView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        secondView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
