//
//  SearchViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/01.
//

import UIKit

class SearchViewController: UIViewController {
	
	static let identifier = "SearchViewController"
	@IBOutlet weak var tableVIew: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableVIew.delegate = self
		tableVIew.dataSource = self

    }
    


}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (UIScreen.main.bounds.height / 5)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
		cell.cellTitleLabel.text = "제목제목제목제목제목제목제목제목제목제목제목제목제목"
		cell.cellDateLabel.text = "2021.11.01"
		cell.cellTextLabel.text = "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용"
		cell.cellTextLabel.numberOfLines = 0
		cell.cellImageView.backgroundColor = .blue
		return cell
	}
	
	
	
}
