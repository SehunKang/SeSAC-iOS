//
//  APIManager.swift
//  SeSAC_KakaoOcrPractice
//
//  Created by Sehun Kang on 2021/10/30.
//

import UIKit.UIImage
import SwiftyJSON
import Alamofire
import UIKit

class APIManager {
	
	static let shared = APIManager()
	
	func fetchTextData(image: UIImage, result: @escaping (Int, JSON) -> () ) {
		
		let header: HTTPHeaders = [
			"Authorization": APIkey.KAKAO,
			"Content-Type": "multipart/form-data" //이 부분은 명시하지 않아도 라이브러리에서 해결해줄 수 있음
		]
			
		//cgsize는 임의로 정함
		let newImage = image.resized(to: CGSize(width: 200, height: 200))
		guard let imageData = newImage.pngData() else {return}
		
		AF.upload(multipartFormData: { multipartFormData in
			multipartFormData.append(imageData, withName: "image", fileName: "image.png")
		}, to: Endpoint.ocrURL, headers: header)
			.validate(statusCode: 200...500).responseJSON { response in
			switch response.result {
			case .success(let value):
				let json = JSON(value)
				print(json)
				let code = response.response?.statusCode ?? 500
				result(code, json)
				
			case .failure(let error):
				print("heeeere")
				print(error)
			}
		}
	}
}

//이미지 리사이징
extension UIImage {
	func resized(to size: CGSize) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { _ in
			draw(in: CGRect(origin: .zero, size: size))
		}
	}
}
