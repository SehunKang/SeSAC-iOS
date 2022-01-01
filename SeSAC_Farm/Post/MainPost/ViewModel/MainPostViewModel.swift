//
//  MainPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation

class MainPostViewModel {
    
    var post: Observable<[EasyPost]> = Observable([])
    
    func getPost(completion: @escaping (APIError?) -> Void) {
        
        APIService.getPost { data, error in
            print(data as Any)
            if data != nil {
                self.post.value = data!
            }
            completion(error)
        }
    }
}

extension MainPostViewModel {
    
    var numberOfSection: Int {
        return post.value.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> EasyPost {
        return post.value[indexPath.section]
    }
}
