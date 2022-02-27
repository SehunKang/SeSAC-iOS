//
//  ViewController.swift
//  SeSAC_MyMemoApp
//
//  Created by Sehun Kang on 2021/11/08.
//

import UIKit
import RealmSwift
import AuthenticationServices

class MainViewController: UIViewController {

	@IBOutlet weak var bottomNavigationBar: UINavigationBar!
	@IBOutlet weak var tableView: UITableView!
	
	let realm = try! Realm()
	var tasks: Results<UserMemo>!
	var notificationToken: NotificationToken?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self

		
		tasks = realm.objects(UserMemo.self)
		addObserver()

		self.view.backgroundColor = .systemGroupedBackground
		setDefaultNavigaionBar()
		setBottomNavBar()
		definesPresentationContext = true
	}
	
	// data가 변할때마다 memoEditedDate를 최신화 해주고 테이블뷰를 리로드해준다.
	func addObserver() {
		
		notificationToken = tasks.observe() { [unowned self] (changes) in
			switch changes {
			case .initial(_):
				self.tableView.reloadData()
			case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
				print("deletions: ", deletions)
				print("insertions: ", insertions)
				print("modification: ", modifications)
//				데이터가 변경될때마다 자동적으로 memoEditedDate을 최신화해주려고 쓴 코드인데
//				뷰 전환시에 동시에 데이터에 write된다고 에러가 뜬다.
//				if modifications.count > 0 {
//					try! self.realm.write {
//					tasks[modifications[0]].memoEditedDate = Date()
//					}
//				}
				// 다른 뷰컨트롤러에는 어떻게 적용할지 모르겠다.
				self.tableView.reloadData()
				self.setNavTitle()
			case .error(let error):
				print(error)
			}
		}
	}

	func setDefaultNavigaionBar() {
		let appearance = UINavigationBarAppearance()
		
//		appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
//		appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
		appearance.configureWithTransparentBackground()
		navigationController?.navigationBar.prefersLargeTitles = true
//		navigationController?.navigationBar.barTintColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
//		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		
		setSearch()
		setNavTitle()

	}
	
	
	func setNavTitle() {
		let numberFormat = NumberFormatter()
		numberFormat.numberStyle = .decimal
		let memoCount = numberFormat.string(for: tasks.count)!
		navigationController?.navigationBar.topItem?.title = "\(memoCount)개의 메모"
		//네비게이션 타이틀이 커질때와 작을때의 타이틀을 다르게 하고싶은데 잘 모르겠다.
	}

	//툴바가 있는줄 모르고 네비게이션바를 하단에 삽입했는데 시간이 없어 안 바꾼다.
	func setBottomNavBar() {
		let appearance = UINavigationBarAppearance()
//		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//		appearance.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
		bottomNavigationBar.standardAppearance = appearance
		bottomNavigationBar.scrollEdgeAppearance = appearance
		let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(writeMemoButtonClicked))
		bottomNavigationBar.topItem?.rightBarButtonItem = writeButton
//		bottomNavigationBar.topItem?.rightBarButtonItem?.tintColor = .systemOrange
		
	}
	
	@objc func writeMemoButtonClicked() {
		let sb = UIStoryboard(name: "Write", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: WriteViewController.identifier) as! WriteViewController
		let task = UserMemo(memoTitle: nil, memoText: nil, memoOriginalText: nil)
		try! realm.write {
			realm.add(task)
		}
		vc.id = task._id
		navigationController?.pushViewController(vc, animated: true)
	}
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
		let label = UILabel()
		label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 5, height: headerView.frame.height - 5)
		label.text = section == 0 ? "고정된 메모" : "메모"
		label.font = .boldSystemFont(ofSize: 30)
		label.textColor = .label
		headerView.addSubview(label)
		
		return headerView
	}
	
	//고정된 메모가 없으면 고정섹션의 높이를 0으로 하여 숨긴다
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			if tasks.filter("memoPinned == true").count == 0 {
				return 0
			} else {
				return 70
			}
		} else {
			return 70
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? tasks.filter("memoPinned == true").count : tasks.filter("memoPinned == false").count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
			let row = tasks.filter("memoPinned == true")[indexPath.row]
			cell.dateMemo.text = getDateFormat(date: row.memoEditedDate)
			cell.textMemo.text = row.memoText
			cell.titleMemo.text = row.memoTitle
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
			let row = tasks.filter("memoPinned == false")[indexPath.row]
			cell.dateMemo.text = getDateFormat(date: row.memoEditedDate)
			cell.textMemo.text = row.memoText
			cell.titleMemo.text = row.memoTitle
			return cell
		}
	}
	
	//데이트로부터 데이터포맷된 스트링을 구한다
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sb = UIStoryboard(name: "Write", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: WriteViewController.identifier) as! WriteViewController
		if indexPath.section == 0 {
			vc.id = tasks.filter("memoPinned == true")[indexPath.row]._id
		} else {
			vc.id = tasks.filter("memoPinned == false")[indexPath.row]._id
		}
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .normal, title: nil) { (action, view, success) in
			if indexPath.section == 0 {
				try! self.realm.write {
					self.tasks.filter("memoPinned == true")[indexPath.row].memoPinned = false
				}
			} else {
				if self.tasks.filter("memoPinned == true").count >= 5 {
					let alert = UIAlertController(title: nil, message: "5개를 초과하여 고정할 수 없습니다", preferredStyle: .alert)
					let ok = UIAlertAction(title: "알겠습니다", style: .cancel, handler: nil)
					alert.addAction(ok)
					self.present(alert, animated: true, completion: nil)
				} else {
					try! self.realm.write {
						self.tasks.filter("memoPinned == false")[indexPath.row].memoPinned = true
					}
				}
			}
		}
		if indexPath.section == 0 {
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

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
	
	func updateSearchResults(for searchController: UISearchController) {
		
		let searchString = searchController.searchBar.text!
		print("from: ", searchString)
		
//		let filteredResults = tasks.filter("memoOriginalText CONTAINS %@", searchString)2

//		print("filter =", filteredResults)
		if let resultsController = searchController.searchResultsController as? SearchViewController {
			resultsController.originatingController = self
			resultsController.tasks = realm.objects(UserMemo.self).filter("memoOriginalText CONTAINS %@", searchString)
			resultsController.searchString = searchString
			resultsController.tableView.reloadData()
		}
			
	}
	
	func setSearch() {
		let sb = UIStoryboard(name: "Search", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: SearchViewController.identifier) as? SearchViewController
		let searchController = UISearchController(searchResultsController: vc)
		searchController.delegate = self
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.autocapitalizationType = .none
		searchController.searchBar.barStyle = .black
		self.navigationItem.searchController = searchController
		
		
	}
	
}
