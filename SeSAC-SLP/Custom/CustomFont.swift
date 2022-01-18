//
//  Font+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/18.
//

import Foundation
import UIKit

enum CustomFont {
    case Display1_R20
    case Title1_M16
    case Title2_R16
    case Title3_M14
    case Title4_R14
    case Title5_M12
    case Title5_R12
    case Body1_M16
    case Body2_R16
    case Body3_R14
    case Body4_R12
    case caption_R10
}

extension CustomFont {
    var font: UIFont {
        switch self {
        case .Display1_R20:
            return UIFont(name: NotoSans.regular.rawValue, size: 20)!
        case .Title1_M16:
            return UIFont(name: NotoSans.medium.rawValue, size: 16)!
        case .Title2_R16:
            return UIFont(name: NotoSans.regular.rawValue, size: 16)!
        case .Title3_M14:
            return UIFont(name: NotoSans.medium.rawValue, size: 14)!
        case .Title4_R14:
            return UIFont(name: NotoSans.regular.rawValue, size: 14)!
        case .Title5_M12:
            return UIFont(name: NotoSans.medium.rawValue, size: 12)!
        case .Title5_R12:
            return UIFont(name: NotoSans.regular.rawValue, size: 12)!
        case .Body1_M16:
            return UIFont(name: NotoSans.medium.rawValue, size: 16)!
        case .Body2_R16:
            return UIFont(name: NotoSans.regular.rawValue, size: 16)!
        case .Body3_R14:
            return UIFont(name: NotoSans.regular.rawValue, size: 14)!
        case .Body4_R12:
            return UIFont(name: NotoSans.regular.rawValue, size: 12)!
        case .caption_R10:
            return UIFont(name: NotoSans.regular.rawValue, size: 10)!
        }
    }
}

enum NotoSans: String {
    case regular = "NotoSansKR-Regular"
    case medium = "NotoSansKR-Medium"
}
