//
//  InfoViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var list = tvShow
	
	@IBOutlet weak var infoTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		infoTableView.delegate = self
		infoTableView.dataSource = self
		overrideUserInterfaceStyle = .dark
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTouched))
		navigationItem.leftBarButtonItem?.tintColor = .white
		let searchBar = UISearchBar()
		self.navigationItem.titleView = searchBar
		searchBar.setImage(UIImage(systemName: "xmark.circle")?.withTintColor(.white), for: .clear, state: .normal)
		if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
			textfield.backgroundColor = .darkGray
			textfield.textColor = .white
			
		}
	}
	
	@objc func closeButtonTouched() {
		dismiss(animated: true, completion: nil)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell else {return UITableViewCell()}
		let content = list[indexPath.row]
		cell.infoImage.image = UIImage(named: content.title)
		cell.infoImage.contentMode = .scaleAspectFit
		cell.infoTitle.text = content.title
		cell.infoTitle.textColor = .white
		cell.infoTitle.font = .systemFont(ofSize: 15)
		cell.infoRealeaseDate.text = content.releaseDate
		cell.infoRealeaseDate.textColor = .white
		cell.infoRealeaseDate.font = .systemFont(ofSize: 11)
		cell.infoSynopsis.text = content.overview
		cell.infoSynopsis.numberOfLines = 3
		cell.infoSynopsis.textColor = .gray
		cell.infoSynopsis.font = .systemFont(ofSize: 10)
		
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

}
