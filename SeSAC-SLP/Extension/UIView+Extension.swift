//
//  UIView+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/04.
//

import Foundation
import UIKit

extension UIView {
    
    func shadowConfig() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
}
