//
//  APIService.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
    case tokenExpired
}

class APIService {
  
    static func signUp(username: String, email: String, password: String, completion: @escaping (SignData?, APIError?) -> Void) {
        
        var request =  URLRequest(url: Endpoint.signup.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func signIn(email: String, password: String, completion: @escaping (SignData?, APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.login.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "identifier=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
//    static func changePassword(currentPassword: String, newPassword: String, confirmNewPassword: String, token: String, completion: @escaping (PasswordData, APIError?) ->Void) {
//
//        var request = URLRequest(url: Endpoint.changePassword.url)
//        request.httpMethod = Method.POST.rawValue
//        request.httpBody = "currentPassword=\(currentPassword)&newPassword=\(newPassword)&confirmNewPassword=\(confirmNewPassword)".data(using: .utf8, allowLossyConversion: false)
//        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
//
//        URLSession.request(endpoint: request, completion: completion)
//    }
    
    static func getPost(completion: @escaping ([Post]?, APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.post.url)
        request.httpMethod = Method.GET.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func getComment(id: Int, completion: @escaping ([DetailComment]?, APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.getComment(postId: id).url)
        request.httpMethod = Method.GET.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func writeComment(id: Int, comment: String, completion: @escaping (APIError?) -> Void ) {
        
        var request = URLRequest(url: Endpoint.comment.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "comment=\(comment)&post=\(id)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func editComment(commentId: Int, postId: Int, text: String, completion: @escaping (APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.commentDetail(id: commentId).url)
        request.httpMethod = Method.PUT.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        struct UploadData: Codable {
            let comment: String
            let post: Int
        }
        let data = UploadData(comment: text, post: postId)
        guard let jsonData = try? JSONEncoder().encode(data) else {
            print("error data convert")
            return
        }
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            completion(nil)
        }.resume()
        
    }
    
    static func deleteComment(commentId: Int, completion: @escaping (APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.commentDetail(id: commentId).url)
        request.httpMethod = Method.DELETE.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func writePost(text: String, completion: @escaping (APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.post.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.request(endpoint: request, completion: completion)
    }
    
    static func editPost(id: Int, text: String, completion: @escaping (APIError?) -> Void) {
        
        struct UploadData: Codable {
            let text: String
        }
        
        var request = URLRequest(url: Endpoint.postDetail(id: id).url)
        request.httpMethod = Method.PUT.rawValue
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let data = UploadData(text: text)
        guard let jsonData = try? JSONEncoder().encode(data) else {
            print("error data convert")
            return
        }
        
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            completion(nil)
        }.resume()

    }
    
    static func deletePost(id: Int, completion: @escaping (APIError?) -> Void) {
        
        var request = URLRequest(url: Endpoint.postDetail(id: id).url)
        request.httpMethod = Method.DELETE.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.request(endpoint: request, completion: completion)
    }
    
}
