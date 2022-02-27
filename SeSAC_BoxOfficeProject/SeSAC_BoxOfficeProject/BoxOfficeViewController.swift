//
//  BoxOfficeViewController.swift
//  SeSAC_BoxOfficeProject
//
//  Created by Sehun Kang on 2021/10/29.
//

import UIKit
import RealmSwift

class BoxOfficeViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var textButton: UIButton!
	
	let localRealm = try! Realm()

	var list: Results<BoxOffficeData>!
	
	var date: Date = Date()

	override func viewDidLoad() {
        super.viewDidLoad()
		
		list = localRealm.objects(BoxOffficeData.self)
		
		tableView.delegate = self
		tableView.dataSource = self
		getData(yyyymmdd: getYesterday())
    }
	
	func getData(yyyymmdd: String) {
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		let searchDate = formatter.date(from: yyyymmdd)!
		for i in list {
			if i.indexDate == searchDate {
				date = searchDate
				return
			}
		}
		getBoxofficeData(yyyymmdd: yyyymmdd) { json in
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			try! self.localRealm.write {
				let boxOfficeData = BoxOffficeData()
				for i in 0...json["boxOfficeResult"]["dailyBoxOfficeList"].count - 1 {
					let boxOffice = BoxOffice()
					boxOffice.rank = i + 1
					boxOffice.movie = json["boxOfficeResult"]["dailyBoxOfficeList"][i]["movieNm"].stringValue
					boxOffice.openDate = formatter.date(from: json["boxOfficeResult"]["dailyBoxOfficeList"][i]["openDt"].stringValue)!
					boxOfficeData.boxOfficeList.append(boxOffice)
					}
				formatter.dateFormat = "yyyyMMdd"
				boxOfficeData.indexDate = formatter.date(from: yyyymmdd)!
				self.localRealm.add(boxOfficeData)
			}
		}
	}
    
	func getYesterday() -> String {
		let calendar = Calendar.current
		let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		return formatter.string(from: yesterday)
	}
	
	@IBAction func textfieldReturnClicked(_ sender: Any) {
		returnButtonClicked(UIButton())
	}
	
	@IBAction func returnButtonClicked(_ sender: Any) {
		getData(yyyymmdd: textField.text ?? getYesterday())
		tableView.reloadData()
	}
	
}

extension BoxOfficeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
		
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoxOfficeTableViewCell", for: indexPath) as? BoxOfficeTableViewCell else { return UITableViewCell() }
		let data = localRealm.objects(BoxOffficeData.self).filter("indexDate == %@", date).first
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		if let boxOffice = data?.boxOfficeList {
			cell.rankLabel.text = "\(boxOffice[indexPath.row].rank)"
			cell.titleLabel.text = boxOffice[indexPath.row].movie
			cell.dateLabel.text = formatter.string(from: boxOffice[indexPath.row].openDate)
		}
		return cell
	}
	
	
}

