//
//  SearchDetailViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/05.
//

import UIKit
import RealmSwift

class SearchDetailViewController: UIViewController {

	static let identifier = "SearchDetailViewController"
	
	let localRealm = try! Realm()
	var task = UserDiary()
	var dataIndex = ObjectId()
	
	var detailImage = UIImage()
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var navigationBar: UINavigationBar!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		task = localRealm.object(ofType: UserDiary.self, forPrimaryKey: dataIndex)!
		print(task.diaryText)
		
		setNavigaionBar()
    }
	
	func setNavigaionBar() {
		let navigationItem = UINavigationItem(title: task.diaryTitle)
		let leftItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: #selector(goBack(_:)))
		navigationItem.leftBarButtonItem = leftItem
		navigationBar.setItems([navigationItem], animated: false)
	}

	@objc func goBack(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}


}

extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return
//	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailTableViewCell.identifier, for: indexPath) as? SearchDetailTableViewCell else {return UITableViewCell()}
//		let cell = SearchDetailTableViewCell()
		let format = DateFormatter()
		format.dateFormat = "yyyy년 MM월 dd일"
		//textView에 텍스트가 안나왔는데 일단 인스펙터에서 scrolling enable을 체크헤제 하였더니 급한대로 나오긴 한다
		cell.detailTextVuew.text = task.diaryText!
		cell.detailDateButton.setTitle(format.string(from: task.writeDate), for: .normal)
		return cell
	}
	
	
}
