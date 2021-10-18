//
//  MainViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit

//UIButton.addtarget의 경우 다른 매개변수를 넣을 수 없어서 UIButton을 커스텀하여 값을 전달할수 있게 만들었다.
class SubclassedUIButton: UIButton {
	var showInfo: TvShow?
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var mainviewTitle: UILabel!
	@IBOutlet weak var searchButton: UIBarButtonItem!
	
	var list = tvShow
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		mainTableView.delegate = self
		mainTableView.dataSource = self
		mainviewTitle.text = "OH JACK!"
		mainviewTitle.textColor = .white
		mainviewTitle.textAlignment = .center
		mainviewTitle.font = .boldSystemFont(ofSize: 30)
		searchButton.image = UIImage(systemName: "magnifyingglass")
		searchButton.tintColor = .black
		
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
		let contentInCell = list[indexPath.section]
		
		cell.mainView.layer.cornerRadius = 10
		cell.mainImage.image = UIImage(named: contentInCell.title)
		cell.mainImage.contentMode = .scaleToFill
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
		cell.webViewButton.showInfo = list[indexPath.section]
		cell.webViewButton.setImage(UIImage(systemName: "paperclip.circle.fill"), for: .normal)
		cell.webViewButton.tintColor = .white
		cell.webViewButton.addTarget(self, action: #selector(webViewButtonTouched), for: .touchUpInside)
		return cell
	}
	
	@objc func webViewButtonTouched(sender: SubclassedUIButton) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
		//새로 열리는 창에 내비게이션컨트롤러를 사용할 수 있게 해줌
		let navController = UINavigationController(rootViewController: vc)
		vc.list = sender.showInfo
		self.present(navController, animated: true, completion: nil)
		
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ("#\(list[section].genre)")
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (UIScreen.main.bounds.height * 0.5)
	}
	
	@IBAction func searchButtonTouched(_ sender: Any) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
		let navController = UINavigationController(rootViewController: vc)
		vc.modalPresentationStyle = .fullScreen
		self.present(navController, animated: true, completion: nil)
	}	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sb = UIStoryboard(name: "Main", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: "CastInfoViewController") as! CastInfoViewController
		vc.list = list[indexPath.section]
		navigationController?.pushViewController(vc, animated: true)
	}
		
}
