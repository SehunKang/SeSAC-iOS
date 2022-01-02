//
//  DetailPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation

class DetailPostViewModel {
    
    var postId: Int!
    
    var post: Post?
    
    var comment: Observable<[DetailComment]> = Observable([])
    
    func getComment(completion: @escaping (APIError?) -> Void) {
        
        APIService.getComment(id: postId) { data, error in
            if data != nil {
                self.comment.value = data!
            }
            completion(error)
        }
    }
    
    func writeComment(comment: String, completion: @escaping (APIError?) -> Void) {
        
        APIService.writeComment(id: postId, comment: comment) { error in
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
