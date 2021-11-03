//
//  BoxOfficeApiManager.swift
//  SeSAC_BoxOfficeProject
//
//  Created by Sehun Kang on 2021/10/29.
//

import Foundation
import Alamofire
import SwiftyJSON

func getBoxofficeData(yyyymmdd: String,  completion: @escaping (JSON) -> Void) {

	
	let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=e9d079cf3a4341c564dbe84b7ba88eab&targetDt=\(yyyymmdd)"

	
	AF.request(url, method: .get).validate().responseJSON { response in
		switch response.result {
		case .success(let value):
			let json = JSON(value)
			//고차함수 사용 실패....
			completion(json)
		case .failure(let error):
			print(error)
		}
	}
}

//returnValue[i][0] =  json["boxOfficeResult"]["dailyBoxOfficeList"][i]["movieNm"].stringValue
//returnValue[i][1] =  json["boxOfficeResult"]["dailyBoxOfficeList"][i]["openDt"].stringValue

