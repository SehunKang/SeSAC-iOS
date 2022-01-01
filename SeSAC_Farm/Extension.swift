//
//  Extension.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation

extension String {

    func dateFormat() -> String? {
        let date2 = self

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: date2) {
            let format = DateFormatter()
            format.dateFormat = "MM/dd"
            return format.string(from: date)
        }
        return nil
    }
}
