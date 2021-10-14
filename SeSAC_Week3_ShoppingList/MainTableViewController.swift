//
//  MainTableViewController.swift
//  SeSAC_Week3_ShoppingList
//
//  Created by Sehun Kang on 2021/10/13.
//

import UIKit

class MainTableViewController: UITableViewController {

	struct ShoppingListStruct {
		var isBought: Bool
		var shoppingListText: String
		var isFavorite: Bool
	}
	
	var shoppingList = [ShoppingListStruct]() {
		didSet {
			saveData()
		}
	}
	
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var mainTitleLabel: UILabel!
	@IBOutlet weak var mainTextField: UITextField!
	@IBOutlet weak var headerView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		headerView.backgroundColor = .systemGray6
		headerView.layer.cornerRadius = 8
		mainTitleLabel.text = "쇼핑"
		mainTitleLabel.font = .systemFont(ofSize: 20)
		mainTextField.borderStyle = .none
		mainTextField.attributedPlaceholder = NSAttributedString(string: "무엇을 구매하실 건가요?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
		addButton.backgroundColor = .systemGray5
		addButton.setAttributedTitle(NSAttributedString(string: "추가", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)] ), for: .normal)
		addButton.layer.cornerRadius = 8
		
		loadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoppingList.count
    }

	@IBAction func addButtonTouched(_ sender: UIButton) {
		if let text = mainTextField.text {
			let newList = ShoppingListStruct(isBought: false, shoppingListText: text, isFavorite: false)
			shoppingList.append(newList)
		} else {
			print("Error at addButtonTouched")
		}
	}
	
	func loadData() {
		let userDefaults = UserDefaults.standard
		
		if let data = userDefaults.object(forKey: "shoppingList") as? [[String:Any]] {
			var list = [ShoppingListStruct]()
			for datum in data {
				guard let isBoughtValue = datum["isBought"] as? Bool else {return}
				guard let shoppingListValue = datum["shoppingList"] as? String else {return}
				guard let isFavoriteValue = datum["isFavorite"] as? Bool else {return}
				list.append(ShoppingListStruct(isBought: isBoughtValue, shoppingListText: shoppingListValue, isFavorite: isFavoriteValue))
			}
			self.shoppingList = list
		}
	}
	
	func saveData() {
		var list: [[String:Any]] = []
		
		for i in shoppingList {
			let data: [String:Any] = [
				"isBought": i.isBought,
				"shoppingList": i.shoppingListText,
				"isFavorite": i.isFavorite
			]
			list.append(data)
		}
		UserDefaults.standard.set(list, forKey: "shoppingList")
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:  "MainTableViewCell", for: indexPath) as? MainTableViewCell  else {
			return UITableViewCell()
		}
		if shoppingList[indexPath.row].isBought == true {
			cell.checkButton.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .normal)
		} else {
			cell.checkButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .normal)
		}
		
		if shoppingList[indexPath.row].isFavorite == true {
			cell.starButton.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
		} else {
			cell.starButton.setImage(UIImage.init(systemName: "star"), for: .normal)
		}
		
		cell.checkButton.setTitle("", for: .normal)
		cell.starButton.setTitle("", for: .normal)
		cell.toDoLabel.text = shoppingList[indexPath.row].shoppingListText
		cell.toDoLabel.backgroundColor = .clear
		cell.viewForCell.backgroundColor = .systemGray5
		cell.viewForCell.layer.cornerRadius = 8
		
		return cell
	}
	@IBAction func checkButtonTouched(_ sender: UIButton) {
		let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
		if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
			if shoppingList[indexPath.row].isBought == true {
				shoppingList[indexPath.row].isBought = false
			} else {
				shoppingList[indexPath.row].isBought = true
			}
		}
	}
	
	@IBAction func starButtonTouched(_ sender: UIButton) {
		let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
		if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
			if shoppingList[indexPath.row].isFavorite == true {
				shoppingList[indexPath.row].isFavorite = false
			} else {
				shoppingList[indexPath.row].isFavorite = true
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			shoppingList.remove(at: indexPath.row)
		}
	}
}
