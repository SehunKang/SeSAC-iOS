//
//  RealmModel.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/02.
//

import Foundation
import RealmSwift

// LocalOnlyQsTask is the Task model for this QuickStart
//UserDiary: 테이블 이름
//@Persisted: 칼럼
class UserDiary: Object {
	
	@Persisted var diaryTitle: String //title(required)
	@Persisted var diaryText: String? //text
	@Persisted var writeDate = Date() //date
	@Persisted var registerDate = Date()
	@Persisted var favorite: Bool
	
	
	//PK(필수): Int, String, UUID, ObjectID -> AutoIncrement
	@Persisted(primaryKey: true) var _id: ObjectId
	
	convenience init(diaryTitle: String, diaryText: String, writeDate: Date, registerDate: Date) {
		self.init()
		
		self.diaryTitle = diaryTitle
		self.diaryText = diaryText
		self.writeDate = writeDate
		self.registerDate = registerDate
		self.favorite = false
	}
}


