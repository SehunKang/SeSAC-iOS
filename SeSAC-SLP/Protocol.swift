//
//  Protocol.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/17.
//

import Foundation
import RxSwift

protocol RxViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set}
    func transform(input: Input) -> Output
}
