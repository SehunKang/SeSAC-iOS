//
//  RealmModel.swift
//  SeSAC_Week3_ShoppingList
//
//  Created by Sehun Kang on 2021/11/02.
//

import Foundation
import RealmSwift

class ShoppingList: Object {
	
	@Persisted var thingToBuy: String
	@Persisted var isStar: Bool
	@Persisted var isCheck: Bool
	@Persisted var createDate = Date()
	
	@Persisted(primaryKey: true) var _id: ObjectId
	
	convenience init(thingToBuy: String, isStar: Bool, isCheck: Bool, createDate: Date) {
		self.init()
		
		self.thingToBuy = thingToBuy
		self.isStar = isStar
		self.isCheck = isCheck
		self.createDate = createDate
	}
	
}

