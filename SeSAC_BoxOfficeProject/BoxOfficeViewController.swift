//
//  BoxOfficeViewController.swift
//  SeSAC_BoxOfficeProject
//
//  Created by Sehun Kang on 2021/10/29.
//

import UIKit

class BoxOfficeViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var textButton: UIButton!
	
	var boxOfficeList: [[String]] = [[String]](repeating: [String](repeating: "" , count: 2), count: 10)

	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		getData(yyyymmdd: getYesterday())
    }
	
	func getData(yyyymmdd: String) {
		getBoxofficeData(yyyymmdd: yyyymmdd) { list in
			self.boxOfficeList = list
			print(self.boxOfficeList)
			self.tableView.reloadData()
		}
	}
    
	func getYesterday() -> String {
		let calendar = Calendar.current
		let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		return formatter.string(from: yesterday!)
	}
	
	@IBAction func textfieldReturnClicked(_ sender: Any) {
		returnButtonClicked(UIButton())
	}
	
	@IBAction func returnButtonClicked(_ sender: Any) {
		getData(yyyymmdd: textField.text ?? "20211028")
	}
	
}

extension BoxOfficeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return boxOfficeList.count
	}
		
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoxOfficeTableViewCell", for: indexPath) as? BoxOfficeTableViewCell else { return UITableViewCell() }
		cell.rankLabel.text = "\(indexPath.row)"
		cell.titleLabel.text = boxOfficeList[indexPath.row][0]
		cell.dateLabel.text = boxOfficeList[indexPath.row][1]
		
		return cell
	}
	
	
}

