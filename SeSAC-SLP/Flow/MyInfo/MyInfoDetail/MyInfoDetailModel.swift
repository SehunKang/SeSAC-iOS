//
//  MyInfoDetailModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/04.
//

import Foundation

struct DataForUpdate {
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    let hobby: String
    
    init(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, hobby: String) {
        self.searchable = searchable
        self.ageMin = ageMin
        self.ageMax = ageMax
        self.gender = gender
        self.hobby = hobby
    }
}
