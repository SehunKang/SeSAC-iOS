//
//  DetailPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation

class DetailPostViewModel {
    
    var postIndex: Int!
    
    var post: Post?
    
    var comment: Observable<[DetailComment]> = Observable([])
    
    func getComment(completion: @escaping (APIError?) -> Void) {
        
        APIService.getComment(id: postIndex) { data, error in
            if data != nil {
                self.comment.value = data!
            }
            completion(error)
        }
    }
    
    
}

extension DetailPostViewModel {
    
    var numberOfSection: Int {
        return 3
    }
    
    var numberOfComment: Int {
        return comment.value.count
    }
    
}
