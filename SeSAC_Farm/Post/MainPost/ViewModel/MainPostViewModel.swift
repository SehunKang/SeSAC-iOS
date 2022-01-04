//
//  MainPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class MainPostViewModel {
    
    var post: Observable<[Post]> = Observable([])
    
    func getPost(refresh: UIRefreshControl? = nil, completion: @escaping (APIError?) -> Void) {
        
        APIService.getPost { data, error in
            
            if refresh != nil {
                refresh?.endRefreshing()
            }
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
    
    func cellForRowAt(at indexPath: IndexPath) -> Post {
        return post.value[indexPath.section]
    }
    
    func pushToDetailPost(_ navigationController: UINavigationController, to viewController: UIViewController, completion: () -> Void) {
    
        
        navigationController.pushViewController(viewController, animated: true)
        completion()
        
    }
    
}
