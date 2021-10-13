//
//  MainTableViewController.swift
//  SeSAC_Week3_ShoppingList
//
//  Created by Sehun Kang on 2021/10/13.
//

import UIKit

class MainTableViewController: UITableViewController {

	
	var shoppingList: [String] = ["쇼핑리스트를 추가해 보세요"] {
		didSet {
			tableView.reloadData()
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
	
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoppingList.count
    }

	@IBAction func buttonTouched(_ sender: UIButton) {
		if mainTextField.text != ""  {
			shoppingList.append(mainTextField.text!)
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:  "MainTableViewCell", for: indexPath) as? MainTableViewCell  else {
			return UITableViewCell()
		}
		
		cell.checkButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .normal)
		cell.checkButton.setTitle("", for: .normal)
		
		cell.starButton.setImage(UIImage.init(systemName: "star"), for: .normal)
		cell.starButton.setTitle("", for: .normal)
		
		cell.toDoLabel.text = shoppingList[indexPath.row]
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
			shoppingList.remove(at: indexPath.row)
		}
	}

	
	

  
}
