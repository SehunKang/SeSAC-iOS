//
//  CastInfoViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit

class CastInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var list = tvShow[whereAmI].starring.components(separatedBy: ", ")
	
	@IBOutlet weak var castTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		print(list)
		castTableView.delegate = self
		castTableView.dataSource = self
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTouched))
		navigationItem.leftBarButtonItem?.tintColor = .black
    }
	
	@objc func backButtonTouched() {
		navigationController?.popViewController(animated: true)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastInfoTableViewCell", for: indexPath) as? CastInfoTableViewCell else {return UITableViewCell()}
		
		cell.castImage.backgroundColor = .black
		cell.castImage.contentMode = .scaleAspectFit
		cell.actorLabel.text = list[indexPath.row]
		cell.actorLabel.textColor = .black
		cell.castLabel.text = "starring"
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

}
