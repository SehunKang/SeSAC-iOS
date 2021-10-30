//
//  InfoViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
	
	//셀이 화면에 보이기 전에 필요한 리소스를 미리 다운받는 기능
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		if let text = self.searchBar.text {
			for indexPath in indexPaths {
				if movieData.count - 1 == indexPath.row {
					startPage += 10
					fetchMovieData(query: text)
					print("prefetch: \(indexPath)")
				}
			}
		}
	}

	//취소
	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		print("cancel:\(indexPaths)")
	}
	
	var list = tvShow
	var movieData: [MovieModel] = []
	
	var startPage = 1
	
	@IBOutlet weak var infoTableView: UITableView!
	
	let searchBar = UISearchBar()

	override func viewDidLoad() {
        super.viewDidLoad()
		//fetchMovieData()
		print(movieData.count, #function)
		infoTableView.delegate = self
		infoTableView.dataSource = self
		infoTableView.prefetchDataSource = self
		
		searchBar.delegate = self
		searchBar.setImage(UIImage(systemName: "xmark.circle")?.withTintColor(.white), for: .clear, state: .normal)

		overrideUserInterfaceStyle = .dark
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTouched))
		navigationItem.leftBarButtonItem?.tintColor = .white
		self.navigationItem.titleView = searchBar
		if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
			textfield.backgroundColor = .darkGray
			textfield.textColor = .white
			
		}
	}
	
	//네이버 영화 네트워크 통신
	func fetchMovieData(query: String) {
		
		let url = "https://openapi.naver.com/v1/search/movie.json"
		let headers: HTTPHeaders = ["X-Naver-Client-Id": "zYGf4zznUG1egirT2ooE", "X-Naver-Client-Secret": "0KT827PQaz"]
		let parameters: Parameters = ["query": query, "display": "10", "start": "\(startPage)"]
		/*or
		if let query = "스파이더맨".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
		 let url ....
		 AF.request(url........................
		 
		*/
		AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
			switch response.result {
			case .success(let value):
				let json = JSON(value)
				print("JSON: \(json)")
				
				for item in json["items"].arrayValue {
					
					let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
					let image = item["image"].stringValue
					let link = item["link"].stringValue
					let userRating = item["userRating"].stringValue
					let sub = item["subtitle"].stringValue
					
					let data = MovieModel(titleData: title , imageData: image, linkData: link, userRatingData: userRating, subtitle: sub)
					
					self.movieData.append(data)
					
				}
				self.infoTableView.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	@objc func closeButtonTouched() {
		dismiss(animated: true, completion: nil)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movieData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell else {return UITableViewCell()}
//		let content = list[indexPath.row]
//		cell.infoImage.image = UIImage(named: content.title)
//		cell.infoImage.contentMode = .scaleAspectFit
//		cell.infoTitle.text = content.title
//		cell.infoTitle.textColor = .white
//		cell.infoTitle.font = .systemFont(ofSize: 15)
//		cell.infoRealeaseDate.text = content.releaseDate
//		cell.infoRealeaseDate.textColor = .white
//		cell.infoRealeaseDate.font = .systemFont(ofSize: 11)
//		cell.infoSynopsis.text = content.overview
//		cell.infoSynopsis.numberOfLines = 3
//		cell.infoSynopsis.textColor = .gray
//		cell.infoSynopsis.font = .systemFont(ofSize: 10)
		
		cell.infoTitle.text = movieData[indexPath.row].titleData
		
		let url = URL(string: movieData[indexPath.row].imageData)
		cell.infoImage.kf.setImage(with: url)

		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}

extension InfoViewController: UISearchBarDelegate {
	
	//테이블뷰의 inspecter 에서 keyboard -> keyboard dismiss on drag 하면 드래그 할 때 키보드가 내려감
	
	//검색 버튼(키보드 리턴키)을 눌렀을 때 실행
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		print(#function)
		if let text = searchBar.text {
			movieData.removeAll()
			startPage = 1
			fetchMovieData(query: text)
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		print(#function)
		movieData.removeAll()
		infoTableView.reloadData()
		searchBar.setShowsCancelButton(true, animated: true)
		//searchBar.showsCancelButton = true 이건 디폴트, 위에가 더 부드럽고 예쁨
	}

	//서치바에서 커서 깜빡이기 시작할 때
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
		print(#function)
	}

}
