//
//  MainTableViewController.swift
//  SeSAC_Week3_ShoppingList
//
//  Created by Sehun Kang on 2021/10/13.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
		
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var mainTitleLabel: UILabel!
	@IBOutlet weak var mainTextField: UITextField!
	@IBOutlet weak var headerView: UIView!
	
	let  localRealm = try! Realm()
	
	var tasks: Results<ShoppingList>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tasks = localRealm.objects(ShoppingList.self)
		
		headerView.backgroundColor = .systemGray6
		headerView.layer.cornerRadius = 8
		mainTitleLabel.text = "쇼핑"
		mainTitleLabel.font = .systemFont(ofSize: 20)
		mainTextField.borderStyle = .none
		mainTextField.attributedPlaceholder = NSAttributedString(string: "무엇을 구매하실 건가요?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
		addButton.backgroundColor = .systemGray5
		addButton.setAttributedTitle(NSAttributedString(string: "추가", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)] ), for: .normal)
		addButton.layer.cornerRadius = 8
		
    }

	@IBAction func checkButtonTouched(_ sender: UIButton) {
		let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
		if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
			try! localRealm.write {
				tasks[indexPath.row].isCheck = !tasks[indexPath.row].isCheck
				print(tasks[indexPath.row].isCheck)
			}
			tableView.reloadData()
		}
	}
	
	@IBAction func starButtonTouched(_ sender: UIButton) {
		let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
		if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
			try! localRealm.write{
				tasks[indexPath.row].isStar = !tasks[indexPath.row].isStar
				print(tasks[indexPath.row].isStar)

			}
			tableView.reloadData()
		}
	}
	
	@IBAction func addButtonTouched(_ sender: UIButton) {
		
		if let text = mainTextField.text {
			let task = ShoppingList(thingToBuy: text, isStar: false, isCheck: false, createDate: Date())
			try! localRealm.write {
				localRealm.add(task)
			}
			tableView.reloadData()
		} else {
			print("Error at addButtonTouched")
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:  "MainTableViewCell", for: indexPath) as? MainTableViewCell  else {
			return UITableViewCell()
		}
		let row = tasks[indexPath.row]
		if row.isCheck == true {
			cell.checkButton.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .normal)
		} else {
			cell.checkButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .normal)
		}
		if row.isStar == true {
			cell.starButton.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
		} else {
			cell.starButton.setImage(UIImage.init(systemName: "star"), for: .normal)
		}
		cell.toDoLabel.text = row.thingToBuy
		cell.toDoLabel.backgroundColor = .clear
		cell.viewForCell.backgroundColor = .systemGray5
		cell.viewForCell.layer.cornerRadius = 8
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			try! localRealm.write {
				localRealm.delete(tasks[indexPath.row])
			}
			tableView.reloadData()
		}
	}
}
