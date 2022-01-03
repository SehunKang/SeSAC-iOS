//
//  Endpoint.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

var token: String = "" {
    didSet {
        UserDefaults.standard.set(token, forKey: "token")
        print(token)
    }
}

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
    case tokenExpired
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoint {
    case signup
    case login
    case changePassword
    case post
    case postDetail(id: Int)
    case getComment(postId: Int) //??
    case comment
    case commentDetail(id: Int)
}

enum ErrorMessage: String {
    case invalidToken = "Invalid token."
}

struct ErrorBody: Codable {
    let statusCode: Int
    let error, message: String
}


extension Endpoint {
    var url: URL {
        switch self {
        case .signup: return .makeEndPoint("auth/local/register")
        case .login: return .makeEndPoint("auth/local")
        case .changePassword: return .makeEndPoint("custom/change-password")
        case .post: return .makeEndPoint("posts")
        case .postDetail(id: let id):
            return .makeEndPoint("posts/\(id)")
        case .getComment(postId: let postId): return .makeEndPoint("comments?post=\(postId)")
        case .comment: return .makeEndPoint("comments")
        case .commentDetail(id: let id): return .makeEndPoint("comments/\(id)")
        }
    }
}


extension URL {
    static let baseURL = "http://test.monocoding.com:1231/"
    
    static func makeEndPoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}

extension URLSession {
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func dataTask(_ endpoint: URLRequest, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: handler)
        task.resume()
        return task
    }
    
    
    static func request<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIError?) -> Void) {
        
        session.dataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completion(nil, .failed)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse)
                    return
                }
                
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(ErrorBody.self, from: data)
                        if jsonData.message == ErrorMessage.invalidToken.rawValue {
                            completion(nil, .tokenExpired)
                            return
                        }
                    } catch {
                        return
                    }
                    completion(nil, .failed)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(T.self, from: data)
                    completion(userData, nil)
                } catch {
                    completion(nil, .invalidData)
                }
            }
        }
    }
    
    static func request(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (APIError?) -> Void) {
        
        session.dataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completion(.failed)
                    return
                }
                
                guard data != nil else {
                    completion(.noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(ErrorBody.self, from: data!)
                        if jsonData.message == ErrorMessage.invalidToken.rawValue {
                            completion(.tokenExpired)
                            return
                        }
                    } catch {
                        return
                    }
                    completion(.failed)
                    return
                }
//                do {
//                    let decoder = JSONDecoder()
//                    let userData = try decoder.decode(Test.self, from: data)
//                    print(userData as Any)
//                } catch {
//                }

                completion(nil)
            }
        }
    }

}
