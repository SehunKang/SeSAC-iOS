//
//  RealmModel.swift
//  SeSAC_BoxOfficeProject
//
//  Created by Sehun Kang on 2021/11/02.
//

import Foundation
import RealmSwift

class BoxOffficeData: Object {
	
	@Persisted var indexDate = Date()
	@Persisted var boxOfficeList: List<BoxOffice>
	
	@Persisted(primaryKey: true) var _id: ObjectId
	
	convenience init(indexDate: Date, boxOfficeList: List<BoxOffice>) {
		self.init()
		
		self.indexDate = indexDate
		self.boxOfficeList = boxOfficeList
	}
	
	
}

class BoxOffice: Object {
	
	@Persisted var rank: Int
	@Persisted var movie: String
	@Persisted var openDate = Date()
	
	convenience init(rank: Int, movie: String, openDate: Date) {
		self.init()
		
		self.rank = rank
		self.movie = movie
		self.openDate = openDate
	}
	
}
