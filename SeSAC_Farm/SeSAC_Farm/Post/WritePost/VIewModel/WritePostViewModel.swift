//
//  WritePostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/02.
//

import UIKit

class WritePostViewModel {
    
    var postId: Int?
    
    func writePost(text: String, completion: @escaping (APIError?) -> Void) {
        
        APIService.writePost(text: text) { error in
            completion(error)
        }
    }
    
    func editPost(text: String, completion: @escaping (APIError?) -> Void) {
        
        APIService.editPost(id: postId!, text: text) { error in
            completion(error)
        }
    }
    

}
