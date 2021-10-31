//
//  CastInfoViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit
import Kingfisher
import SwiftUI

class CastInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//	var castList: [String]
//	var headerView: String
	var list: TvShow?
	
	var detailedInfo: DetailedTvInfo?
	
	var isAdditionalInfoButtonTouched = false
	
	@IBOutlet weak var castTableView: UITableView!

	override func viewDidLoad() {
        super.viewDidLoad()
		castTableView.delegate = self
		castTableView.dataSource = self
		
		//xib파일 연결
		let nibName = UINib(nibName: "AdditionalInfoTableViewCell", bundle: nil)
		castTableView.register(nibName, forCellReuseIdentifier: "AdditionalInfoTableViewCell")
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTouched))
		navigationItem.leftBarButtonItem?.tintColor = .black
	
		castTableView.rowHeight = UITableView.automaticDimension
    }
	
	@objc func backButtonTouched() {
		navigationController?.popViewController(animated: true)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : detailedInfo?.character.count ?? 0
		}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 1 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastInfoTableViewCell", for: indexPath) as? CastInfoTableViewCell else {return UITableViewCell()}
			cell.castImage.backgroundColor = .black
			cell.castImage.contentMode = .scaleAspectFit
			let url = URL(string: "https://image.tmdb.org/t/p/w300\(detailedInfo!.actorImageURL[indexPath.row])")
			cell.castImage.kf.setImage(with: url)
			cell.actorLabel.text = detailedInfo?.actor[indexPath.row]
			cell.actorLabel.textColor = .black
			cell.castLabel.text = detailedInfo?.character[indexPath.row]
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoTableViewCell", for: indexPath) as? AdditionalInfoTableViewCell else {return UITableViewCell()}
			cell.tag = 0
			cell.additionalInfoButton.tag = cell.tag
			cell.additionalInfoLabel.text = detailedInfo!.overview
			cell.additionalInfoLabel.numberOfLines = isAdditionalInfoButtonTouched ? 0 : 2
			cell.additionalInfoButton.setImage(UIImage(systemName: isAdditionalInfoButtonTouched == true ? "chevron.up" : "chevron.down"), for: .normal)
			cell.additionalInfoButton.addTarget(self, action: #selector(additionalInfoButtonTouched), for: .touchUpInside)
			return cell
		}

	}
	@objc func additionalInfoButtonTouched() {
		isAdditionalInfoButtonTouched = !isAdditionalInfoButtonTouched
		castTableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
		
	}

//	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 1000
//	}
//아래의 메서드가 viewdidload에서의 rowheight프러퍼티보다 더 높은 우선순위를 가진다
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			if isAdditionalInfoButtonTouched == true {
				return UITableView.automaticDimension
			} else {
				return 100
			}
		} else {
			return 100
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? (UIScreen.main.bounds.height / 4) : 0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			let imageView = UIImageView()
			let url = URL(string: "https://image.tmdb.org/t/p/w300\(detailedInfo!.backdropImageUrl)")
			imageView.kf.setImage(with: url)
			return imageView
		} else {
			return nil
		}
	}
}
