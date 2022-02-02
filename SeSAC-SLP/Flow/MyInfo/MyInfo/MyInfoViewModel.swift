//
//  MyInfoViewModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/02.
//

import UIKit
import Moya

class MyInfoViewModel {
    
    
    func numberOfRowsInSection() -> Int {
        return MyInfoList.allCases.count
    }
    
    func getCellItems() -> [String] {
        return MyInfoList.allCases.map {$0.title}
    }
    
    func getCellImages() -> [UIImage] {
        return MyInfoList.allCases.map {$0.image}
    }
    
}

