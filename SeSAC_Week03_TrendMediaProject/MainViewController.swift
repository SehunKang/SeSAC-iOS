//
//  MainViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var viewOfThreeButtons: UIView!
	@IBOutlet weak var bookButton: UIButton!
	@IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var mainviewTitle: UILabel!
	@IBOutlet weak var searchButton: UIBarButtonItem!
	@IBOutlet weak var mapButton: UIBarButtonItem!
	
	var list = tvShow
	var tvInfo: [TvInfo] = [] {
		didSet {
			mainTableView.reloadData()
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		
		//머리가 나쁘면 머리도 몸도 고생
		APIManager.shared.fetchTextData(apiURL: "https://api.themoviedb.org/3/trending/tv/week", page: 1, language: "ko") { json in
			for i in 0...json["results"].count - 1 {
				var intForGenre: [Int] = []
				for j in 0...json["results"][i]["genre_id"].count { intForGenre.append(json["results"][i]["genre_id"][j].intValue) }
				let value = TvInfo(
					title: json["results"][i]["name"].stringValue,
					releaseDate: json["results"][i]["first_air_date"].stringValue,
					genre: intForGenre,
					id: json["results"][i]["id"].intValue,
					rate: json["results"][i]["vote_average"].doubleValue,
					posterImageUrl: json["results"][i]["poster_path"].stringValue,
					overview: json["results"][i]["overview"].stringValue,
					backdropImageUrl: json["results"][i]["backdrop_path"].stringValue
				)
				self.tvInfo.append(value)
			}
		}
		
		viewOfThreeButtons.layer.cornerRadius = 8
		mainTableView.delegate = self
		mainTableView.dataSource = self
		mainviewTitle.text = "MAIN TITLE"
		mainviewTitle.textColor = .white
		mainviewTitle.textAlignment = .center
		mainviewTitle.font = .boldSystemFont(ofSize: 30)
		searchButton.image = UIImage(systemName: "magnifyingglass")
		searchButton.tintColor = .black
		mapButton.image = UIImage(systemName: "map")
		mapButton.tintColor = .black
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		print("**************\(tvInfo.count)")
		return tvInfo.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
		let contentInCell = tvInfo[indexPath.section]
		print(indexPath.section)
		
		cell.mainView.layer.cornerRadius = 10
		let url = URL(string: "https://image.tmdb.org/t/p/w300\(contentInCell.posterImageUrl)")
		cell.mainImage.kf.setImage(with: url)
		cell.mainImage.contentMode = .scaleAspectFit
		cell.rateLabel.text = String(contentInCell.rate)
		cell.rateLabel.font = .systemFont(ofSize: 12)
		cell.rateLabel.backgroundColor = .white
		cell.rateLabel.textAlignment = .center
		cell.expectationLabel.text = "예상"
		cell.expectationLabel.font = .systemFont(ofSize: 12)
		cell.expectationLabel.textAlignment = .center
		cell.expectationLabel.backgroundColor = .orange
		cell.movieNameLabel.text = contentInCell.title
		cell.movieNameLabel.font = .systemFont(ofSize: 20)
		cell.releaseDateLabel.text = contentInCell.releaseDate
		cell.releaseDateLabel.font = .systemFont(ofSize: 15)
		cell.releaseDateLabel.textColor = .systemGray3
		cell.alikeContentsRecommendLabel.text = "비슷한 컨텐츠 보기"
		cell.alikeContentsRecommendLabel.font = .systemFont(ofSize: 15)
		cell.alikeContentsRecommendButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		cell.alikeContentsRecommendButton.tintColor = .black
		cell.webViewButton.tintColor = .black
		cell.webViewButton.tag = indexPath.section
		cell.webViewButton.addTarget(self, action: #selector(webViewButtonTouched), for: .touchUpInside)
		return cell
	}
	
	@objc func webViewButtonTouched(sender: UIButton) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
		//새로 열리는 창에 내비게이션컨트롤러를 사용할 수 있게 해줌
		let navController = UINavigationController(rootViewController: vc)
		vc.list = tvInfo[sender.tag]
		let id = tvInfo[sender.tag].id
		//언어를 한국어로 설정했을 때 없는 경우가 있음
		APIManager.shared.fetchTextData(apiURL:"https://api.themoviedb.org/3/tv/\(id)/videos", page: 1, language: "ko", result: { json in
			
			if let url = json["results"][0]["key"].string {
				vc.destinationURL = "https://youtube.com/watch?v=\(url)"
				self.present(navController, animated: true, completion: nil)
			} else {
				APIManager.shared.fetchTextData(apiURL: "https://api.themoviedb.org/3/tv/\(id)/videos", page: 1, language: "en") { newJson in
					vc.destinationURL = "https://youtube.com/watch?v=\(newJson["results"][0]["key"].stringValue)"
					self.present(navController, animated: true, completion: nil)
				}
			}
		})
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		var returnValue: String = ""
//		for i in 0...tvInfo[section].genre.count - 1{
//			let genreString = "#\(Genre.genreDictionary[tvInfo[section].genre[i]]) "
//			returnValue.append(genreString)
//		}
//		print(Genre.genreDictionary[tvInfo[0].genre[0]])
		return ("보류")
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (UIScreen.main.bounds.height * 0.5)
	}
	
	@IBAction func bookButtonTouched(_ sender: Any) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "BookTableViewController") as! BookTableViewController
		vc.list = list
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func searchButtonTouched(_ sender: Any) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
		let navController = UINavigationController(rootViewController: vc)
		vc.modalPresentationStyle = .fullScreen
		self.present(navController, animated: true, completion: nil)
	}
	
	@IBAction func mapButtonTouched(_ sender: UIBarButtonItem) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
		navigationController?.pushViewController(vc, animated: true)
		
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "CastInfoViewController") as! CastInfoViewController
		let id = tvInfo[indexPath.section].id
		APIManager.shared.fetchTextData(apiURL: "https://api.themoviedb.org/3/tv/\(id)/credits", page: 1, language: "ko") { json in
			var actorlist: [String] = []
			var characterlist: [String] = []
			var imageURLlist: [String] = []
			for i in 0...json["cast"].count - 1 {
				actorlist.append(json["cast"][i]["name"].stringValue)
				characterlist.append(json["cast"][i]["character"].stringValue)
				imageURLlist.append(json["cast"][i]["profile_path"].stringValue)
			}
			let detailedInfo = DetailedTvInfo(
				character: characterlist,
				actor: actorlist,
				actorImageURL: imageURLlist,
				overview: self.tvInfo[indexPath.section].overview,
				backdropImageUrl: self.tvInfo[indexPath.section].backdropImageUrl)
			vc.detailedInfo = detailedInfo
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
