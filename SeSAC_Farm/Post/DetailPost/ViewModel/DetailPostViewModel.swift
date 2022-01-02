//
//  DetailPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation
import UIKit

class DetailPostViewModel {
    
    var postId: Int!
    var postIndex: Int!
    
    var post: Observable<Post> = Observable(Post(id: 0, text: "", user: UserFromPost(id: 0, username: "", email: "", provider: "", confirmed: true, blocked: nil, role: 0, createdAt: "", updatedAt: ""), createdAt: "", updatedAt: "", comments: []))
    
    var comment: Observable<[DetailComment]> = Observable([])
    
    func getComment(completion: @escaping (APIError?) -> Void) {
        
        APIService.getComment(id: postId) { data, error in
            if data != nil {
                self.comment.value = data!
            }
            completion(error)
        }
    }
    
    func updateComment() {
        APIService.getComment(id: postId) { data, error in
            if data != nil {
                self.comment.value = data!
            }
        }
    }
    
    func updatePost() {
        APIService.getPost { data, error in
            if data != nil {
                self.post.value = data![self.postIndex]
            }
        }
    }
    
    func writeComment(comment: String, completion: @escaping (APIError?) -> Void) {
        
        APIService.writeComment(id: postId, comment: comment) { error in
            completion(error)
        }
    }
    
    func deletePost(completion: @escaping (APIError?) -> Void) {
        
        APIService.deletePost(id: postId) { error in
            completion(error)
        }
    }
    
    func editComment(commentId: Int, text: String, postId: Int, completion: @escaping (APIError?) -> Void) {
        print(commentId, text, postId)
        APIService.editComment(commentId: commentId, postId: postId, text: text) { error in
            print(commentId, postId, text)
            completion(error)
        }
        
    }
    
    func deleteCommet(commentId: Int, completion: @escaping (APIError?) -> Void) {
        
        APIService.deleteComment(commentId: commentId) { error in
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
