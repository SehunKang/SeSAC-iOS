//
//  UIColor+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/18.
//

import Foundation
import UIKit

enum CustomColor: String {
    case SLPBlack
    case SLPError
    case SLPFocus
    case SLPGray1
    case SLPGray2
    case SLPGray3
    case SLPGray4
    case SLPGray5
    case SLPGray6
    case SLPGray7
    case SLPGreen
    case SLPSuccess
    case SLPWhite
    case SLPWhiteGreen
    case SLPYellowgreen
}

extension CustomColor {
    var color: UIColor {
        return UIColor(named: self.rawValue)!
    }
}
