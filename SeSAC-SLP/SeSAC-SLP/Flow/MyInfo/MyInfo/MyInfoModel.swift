//
//  MyInfoModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/02.
//

import Foundation
import UIKit

enum MyInfoList: CaseIterable {
    case name, announcement, questions, faq, alarm, termsofservice
    
    var title: String {
        switch self {
        case .name:
            return UserDefaultManager.userData?.nick ?? "error in userData"
        case .announcement:
            return "공지사항"
        case .questions:
            return "자주 묻는 질문"
        case .faq:
            return "1:1 문의"
        case .alarm:
            return "알림설정"
        case .termsofservice:
            return "이용 약관"
        }
    }
    
    var image: UIImage {
        switch self {
        case .name:
            return UIImage(named: "sesac_face_1")!
        case .announcement:
            return UIImage(named: "notice")!
        case .questions:
            return UIImage(named: "faq")!
        case .faq:
            return UIImage(named: "qna")!
        case .alarm:
            return UIImage(named: "setting_alarm")!
        case .termsofservice:
            return UIImage(named: "permit")!
        }
    }
    
}
