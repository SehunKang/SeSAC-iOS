//
//  APIService.swift
//  TMDB_API_Prac
//
//  Created by Sehun Kang on 2021/12/26.
//

import Foundation
import UIKit

class APIService {
    
    func requestSearch(searchQuery: String, page: Int = 1, completion: @escaping (TVshow?) -> Void) {
        
        print("request for query: ", searchQuery)
        
        var urlComponent = URLComponents(string: "https://api.themoviedb.org/3/search/tv?")
        
        let apiKey = URLQueryItem(name: "api_key", value: apiKey)
        let language = URLQueryItem(name: "language", value: "ko-KR")
        let query = URLQueryItem(name: "query", value: searchQuery)
        let include = URLQueryItem(name: "include_adult", value: "true")
        let page = URLQueryItem(name: "page", value: "\(page)")
        
        urlComponent?.queryItems?.append(apiKey)
        urlComponent?.queryItems?.append(language)
        urlComponent?.queryItems?.append(query)
        urlComponent?.queryItems?.append(include)
        urlComponent?.queryItems?.append(page)

        
        let url = (urlComponent?.url)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            print(data)
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print(response)
                return
            }
            
            if let data = data, let TVShowData = try? JSONDecoder().decode(TVshow.self, from: data) {
                completion(TVShowData)
                return
            }
//            completion(nil)
        }.resume()
    }
    
    func requestPoster(posterPath: String, completion: @escaping (UIImage) -> Void) {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(posterPath)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print(response)
                return
            }
            
            if let data = data {
                guard let image = UIImage(data: data) else {return}
                completion(image)
                return
            }
            
        }.resume()
    }
    
    func requestTvShowDetail(id: Int, completion: @escaping (TvShowDetail?) -> Void) {
        
        var urlComponent = URLComponents(string: "https://api.themoviedb.org/3/tv/\(id)")!

        let queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "language", value: "ko-KR")]
        
        urlComponent.queryItems = queryItems
        
        let url = urlComponent.url!
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print(response)
                return
            }
            
            if let data = data, let detailData = try? JSONDecoder().decode(TvShowDetail.self, from: data) {
                completion(detailData)
            }
            
        }.resume()
    }
    
}
