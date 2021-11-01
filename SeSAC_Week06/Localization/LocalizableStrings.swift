//
//  LocalizableStrings.swift
//  SeSAC_Week05
//
//  Created by Sehun Kang on 2021/11/01.
//

import Foundation

enum LocalizableStrings: String {
	case welcome_text
	case data_backup
	case content_title
	case save
	
	
	var localized: String {
		return self.rawValue.localized() // Localizable.strings
	}
	
	var localizedSetting: String {
		return self.rawValue.localized(tableName: "Setting") // Localizable.strings
	}

}
