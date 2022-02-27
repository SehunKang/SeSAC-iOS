//
//  NickNameViewModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class NickNameViewModel {
    var disposeBag = DisposeBag()
    
    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let newText: Observable<String>
        let sceneTransition: ControlEvent<Void>
        
    }
    
    func transform(input: Input) -> Output {
        
        let validStatus = input.text
            .orEmpty
            .map { $0.count < 1}
            .share(replay: 1, scope: .whileConnected)
        
        let newText = input.text
            .orEmpty
            .map {String($0.prefix(10)) }
            .share(replay: 1, scope: .whileConnected)
        
        
        return Output(validStatus: validStatus, newText: newText, sceneTransition: input.tap)
    }
    
}
