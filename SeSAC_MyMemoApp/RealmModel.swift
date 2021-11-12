//
//  RealmModel.swift
//  SeSAC_MyMemoApp
//
//  Created by Sehun Kang on 2021/11/10.
//

import Foundation
import RealmSwift

class UserMemo: Object {
	
	@Persisted var memoTitle: String?
	@Persisted var memoText: String?
	@Persisted var memoOriginalText: String?
	@Persisted var memoEditedDate = Date()
	@Persisted var memoOriginalDate = Date()
	@Persisted var memoPinned: Bool
	
	@Persisted(primaryKey: true)var _id: ObjectId
	
	convenience init(memoTitle: String?, memoText: String?, memoOriginalText: String?) {
		self.init()
		
		self.memoTitle = memoTitle
		self.memoText = memoText
		self.memoOriginalText = memoOriginalText
		self.memoPinned = false
	}
}
