//
//  InitalView.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class InitialView: UIView {
    
    let centerView = CenterCustomView()
    
    let startButton = StartButtonView()
    
    let signUpCheckView = SignUpCheckView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
        
        self.addSubview(signUpCheckView)
        signUpCheckView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(40)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(signUpCheckView.snp.top).offset(-15)
            make.height.equalTo(44)
        }
        
    }
            
    required init?(coder: NSCoder) {
        fatalError()
    }
}
