//
//  APIManager.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/30.
//

import Foundation
import Alamofire
import SwiftyJSON


class APIManager {
	
	static let shared = APIManager()
	
	func fetchTextData(apiURL: String, page: Int, language: String, result: @escaping (JSON) -> () ) {
	
		let url = apiURL
		let parameter: Parameters = ["api_key": APIkey.TMDBkey, "language": language, "page": String(page)]

		
		AF.request(url, method: .get, parameters: parameter).validate().responseJSON { response in
			switch response.result {
			case .success(let value):
				let json = JSON(value)
				result(json)
				//print("JSON: \(json)")
			case .failure(let error):
				print(error)
			}
		}
	}
}
