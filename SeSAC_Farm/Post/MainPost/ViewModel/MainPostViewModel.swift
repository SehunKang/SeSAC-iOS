//
//  MainPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation

class MainPostViewModel {
    
    var post: [Post]!
    
    func getPost(completion: @escaping (APIError?) -> Void) {
        
        APIService.getPost { data, error in
            if data != nil {
                self.post = data
            }
            completion(error)
        }
    }
}

extension MainPostViewModel {
    
    var numberOfSection: Int {
        return post.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> Post {
        return post[indexPath.section]
    }
}
