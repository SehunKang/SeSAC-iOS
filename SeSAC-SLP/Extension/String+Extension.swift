//
//  String+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/22.
//

import Foundation

extension String {
    
    var validatePhoneNumber: Bool {
        get {
            let regex = "^01[0-9]+-[0-9]{3,4}+-[0-9]{4}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: self)
        }
    }
    
    var validateEmail: Bool {
        get {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: self)
        }
    }
}
