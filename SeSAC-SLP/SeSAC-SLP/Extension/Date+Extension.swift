//
//  Date+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/15.
//

import Foundation

extension Date {
    
    var toString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            let dateString = formatter.string(from: self)
            return dateString
        }
    }
    
    var timeFilter: String {
        get {
            let formatter = DateFormatter()
            
            let calendar = Calendar.current
            if calendar.isDateInToday(self) {
                formatter.dateFormat = "a hh:mm"
            } else {
                formatter.dateFormat = "MM/dd a hh:mm"
            }
            return formatter.string(from: self)
        }
    }
    
    
}
