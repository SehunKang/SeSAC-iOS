//
//  UILabel+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/03.
//

import Foundation
import UIKit

extension UILabel {
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview != nil else {
            return
        }
        
        if textColor == UIColor.label {
            textColor = CustomColor.SLPBlack.color
        }
    }
}
