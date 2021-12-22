//
//  APIService.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/22.
//

import Foundation

enum APIError: String, Error {
    case unknownError = "alert_error_unkown"
    case serverError = "alert_error_server"
}

extension APIError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString(self.rawValue, comment: "")
        case .serverError:
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}

class APIService {
    
    let sourceURL = URL(string: "https://api.punkapi.com/v2/beers/random")!
    func requestCast(completion: @escaping (BeerElement?) -> Void) {

        URLSession.shared.dataTask(with: sourceURL) { data, response, error in

            print("data: ", data as Any)
            print("response: ", response as Any)
            print("error: ", error as Any)

            if let error = error {
                self.showAlert(.unknownError)
                print(error)
                print("ERRRor")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                self.showAlert(.serverError)
                print("200")
                return
            }
            if let data = data, let beer = try?
                JSONDecoder().decode([BeerElement].self, from: data) {
                print("****************Succeed*****************")
                print(beer as Any)
                completion(beer.first)
                return
            }
//            do {
//                let decoder = JSONDecoder()
//                let beer = try decoder.decode(BeerElement.self, from: data!)
//                print(beer as Any)
//            } catch DecodingError.dataCorrupted(let context) {
//                print(context)
//            } catch DecodingError.keyNotFound(let key, let context) {
//                print("Key '\(key)' not found:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//            } catch DecodingError.valueNotFound(let value, let context) {
//                print("Value '\(value)' not found:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//            } catch DecodingError.typeMismatch(let type, let context) {
//                print("Type '\(type)' mismatch:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//            } catch {
//                print("error: ", error)
//            }
            completion(nil)
        }.resume()
    }

    func showAlert(_ msg: APIError) {

    }

}
