//
//  SearchViewController.swift
//  SeSAC_MyMemoApp
//
//  Created by Sehun Kang on 2021/11/12.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
	var originatingController: MainViewController?
	
	static let identifier = "SearchViewController"

	@IBOutlet weak var tableView: UITableView!
	
	let realm = try! Realm()
	var tasks: Results<UserMemo>!

	var searchString: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		tableView.delegate = self
		tableView.dataSource = self
		definesPresentationContext = true
		
		tableView.keyboardDismissMode = .onDrag
    }
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
//		let index = tasks[indexPath.row].
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
		let row = tasks[indexPath.row]
		cell.searchTitle.setHighlighted(row.memoTitle!, with: searchString)
		cell.searchText.setHighlighted(row.memoText!, with: searchString)
//		cell.searchText.text = row.memoText
		cell.searchDate.text = getDateFormat(date: row.memoEditedDate)
		
		return cell
	}

	//귀찮아서 복붙함
	func getDateFormat(date: Date) -> String {
		let formatter = DateFormatter()
		let today = Calendar.current.dateComponents([.weekOfYear, .day], from: Date())
		let dateOfData = Calendar.current.dateComponents([.weekOfYear, .day], from: date)
		if today.weekOfYear == dateOfData.weekOfYear {
			if today.day == dateOfData.day {
				formatter.dateFormat = "a hh:mm"
			} else {
				formatter.dateFormat = "EEEE"
			}
		} else {
			formatter.dateFormat = "yyyy. MM. dd a hh:mm"
		}
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}



	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
		let label = UILabel()
		label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 5, height: headerView.frame.height - 5)
		label.text = "\(tasks.count)개 찾음"
		label.font = .boldSystemFont(ofSize: 30)
		label.textColor = .label
		headerView.addSubview(label)

		return headerView

	}
	
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sb = UIStoryboard(name: "Write", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: WriteViewController.identifier) as! WriteViewController
		vc.id = tasks[indexPath.row]._id
		self.originatingController?.navigationItem.title = "검색"
		self.originatingController?.navigationController?.pushViewController(vc, animated: true)
	}

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let totalPinned = realm.objects(UserMemo.self).filter("memoPinned == true").count
		let action = UIContextualAction(style: .normal, title: nil) { (action, view, success)  in
			if totalPinned >= 5 {
				let alert = UIAlertController(title: nil, message: "5개를 초과하여 고정할 수 없습니다", preferredStyle: .alert)
				let ok = UIAlertAction(title: "알겠습니다", style: .cancel, handler: nil)
				alert.addAction(ok)
				self.present(alert, animated: true, completion: nil)
			} else {
				try! self.realm.write {
					self.tasks[indexPath.row].memoPinned = !self.tasks[indexPath.row].memoPinned
				}
			}
			self.tableView.reloadData()
		}
		if tasks[indexPath.row].memoPinned == true {
			action.image = UIImage(systemName: "pin.slash.fill")
		} else {
			action.image = UIImage(systemName: "pin.fill")
		}
		action.backgroundColor = .systemOrange
		return UISwipeActionsConfiguration(actions: [action])
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .destructive, title: nil) { (action, view, success) in
			let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
			let ok = UIAlertAction(title: "네", style: .default) { _ in
				try! self.realm.write {
					self.realm.delete(self.tasks[indexPath.row])
				}
				self.tableView.reloadData()
			}
			let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
			alert.addAction(ok)
			alert.addAction(cancel)
			self.present(alert, animated: true, completion: nil)
		}
		action.image = UIImage(systemName: "trash.fill")
		return UISwipeActionsConfiguration(actions: [action])
	}
}

extension UILabel {
	func setHighlighted(_ text: String, with search: String) {
		let attributedText = NSMutableAttributedString(string: text)
		let range = NSString(string: text).range(of: search, options: .caseInsensitive)
		let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
		
		attributedText.addAttributes(highlightedAttributes, range: range)
		self.attributedText = attributedText
	}
}
