//
//  SearchViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
	
	static let identifier = "SearchViewController"
	@IBOutlet weak var tableVIew: UITableView!
	
	let localRealm = try! Realm()
	
	var tasks: Results<UserDiary>!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableVIew.delegate = self
		tableVIew.dataSource = self
		
		tasks = localRealm.objects(UserDiary.self)
		print(localRealm.configuration.fileURL!)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableVIew.reloadData()
	}

	func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
		
		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
		let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
		
		if let directoryPath = path.first {
			let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
			return UIImage(contentsOfFile: imageURL.path)
		}
		return nil
	}
	
	//이미지 삭제
	func deleteImgaeFromDocumentDirectory(imageName: String) {
		//1. 이미지 저장할 경로 설정: 도큐먼트 폴더(.documentDirectory), FileManager
		//ex. Desktop/jack/ios/foler
		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		
		//2. 이미지 파일 이름
		//ex. Desktop/jack/ios/filder/222.png
		let imageURL = documentDirectory.appendingPathComponent(imageName)
		
		//4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우
		//4-1. 이미지 경로 여부 확인
		if FileManager.default.fileExists(atPath: imageURL.path) {
			
			//4-2. 기존 경로에 있는 이미지 삭제
			do {
				try FileManager.default.removeItem(atPath: imageURL.path)
				print("image deleted")
			} catch {
				print("error")
			}
		}
		
	}
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (UIScreen.main.bounds.height / 5)
	}
	
	//
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let taskToUpdate = tasks[indexPath.row]
		
		guard let vc = self.storyboard?.instantiateViewController(withIdentifier: SearchDetailViewController.identifier) as? SearchDetailViewController else { return }
		vc.modalPresentationStyle = .fullScreen
		vc.dataIndex = taskToUpdate._id
		self.present(vc, animated: true, completion: nil)

		//1. 수정 = 레코드에 대한 값 수정
//		try! localRealm.write {
//			taskToUpdate.diaryTitle = "new Title"
//			taskToUpdate.diaryText = "new text"
//			tableView.reloadData()
//		}
		
		//2. 일괄 수정
//		try! localRealm.write {
//			tasks.setValue(Date(), forKey: "writeDate")
//			tableView.reloadData()
//		}
		
		//3. 수정: pk 기준으로 수정할 때 사용 (권장하지 않음)
//		try! localRealm.write {
//			let update = UserDiary(value: ["_id": taskToUpdate._id, "diaryTitle": "change main"])
//			localRealm.add(update, update: .modified)
//			tableView.reloadData()
//		}
		
		//4.
//		try! localRealm.write {
//			localRealm.create(UserDiary.self, value: ["_id": taskToUpdate._id, "diaryTitle": "change main"], update: .modified)
//			tableView.reloadData()
//		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
		let row = tasks[indexPath.row]
		
		cell.cellImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).jpg")
		
		cell.cellTitleLabel.text = row.diaryTitle
		
		let format = DateFormatter()
		format.dateFormat = "yyyy년 MM월 dd일"
		cell.cellDateLabel.text = format.string(from: row.writeDate)
		cell.cellTextLabel.text = row.diaryText
		cell.cellTextLabel.numberOfLines = 0
		cell.cellImageView.backgroundColor = .blue
		return cell
	}
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		try! localRealm.write {
			
			deleteImgaeFromDocumentDirectory(imageName: "\(tasks[indexPath.row]._id).jpg")
			localRealm.delete(tasks[indexPath.row])

			tableView.reloadData()
		}
	}
	
}
