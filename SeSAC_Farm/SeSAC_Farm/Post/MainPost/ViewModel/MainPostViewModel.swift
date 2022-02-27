//
//  MainPostViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class MainPostViewModel {
    
    var totalPost: Int = 0
    var currentPage: Int = 0
    
    var post: Observable<[Post]> = Observable([])
    
    func getPost(refresh: UIRefreshControl? = nil, isInitialCall: Bool? = false, completion: @escaping (APIError?) -> Void) {
        
        if isInitialCall == true || refresh != nil {
            self.currentPage = 0
            APIService.getTotalPostCount { count, error in
                if let count = count {
                    self.totalPost = count
                }
            }
        }
        
        APIService.getPage(page: currentPage) { data, error in
            refresh?.endRefreshing()
            if data != nil {
                self.currentPage += 1
                if refresh == nil {
                    self.post.value.append(contentsOf: data!)
                } else if isInitialCall == true || refresh != nil{
                    self.post.value = data!
                }
            }
            completion(error)
        }
        
//        APIService.getPost { data, error in
//
//            refresh?.endRefreshing()
//            if data != nil {
//                self.post.value = data!
//            }
//
//            completion(error)
//        }
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
