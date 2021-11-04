//
//  MainTableViewController.swift
//  SeSAC_Week3_ShoppingList
//
//  Created by Sehun Kang on 2021/10/13.
//

import UIKit
import MobileCoreServices
import RealmSwift
import Zip
import JGProgressHUD


class MainTableViewController: UITableViewController {
		
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var mainTitleLabel: UILabel!
	@IBOutlet weak var mainTextField: UITextField!
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var sortButton: UIButton!
	@IBOutlet weak var backupButton: UIButton!
	
	let  localRealm = try! Realm()
	
	var tasks: Results<ShoppingList>!
	
	let hud = JGProgressHUD()
	
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
	
//	override func viewWillDisappear(_ animated: Bool) {
//		super.viewWillDisappear(animated)
//		try! localRealm.write {
//			localRealm.add(tasks, update: .all)
//		}
//	}

	@IBAction func checkButtonClicked(_ sender: UIButton) {
		let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
		if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
			try! localRealm.write {
				tasks[indexPath.row].isCheck = !tasks[indexPath.row].isCheck
			}
			tableView.reloadData()
		}
	}
	
	@IBAction func starButtonClicked(_ sender: UIButton) {
		let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
		if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
			try! localRealm.write{
				tasks[indexPath.row].isStar = !tasks[indexPath.row].isStar
			}
			tableView.reloadData()
		}
	}
	@IBAction func keyboardReturn(_ sender: Any) {
		addButtonClicked(addButton)
	}
	
	@IBAction func addButtonClicked(_ sender: UIButton) {
		
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
	
	@IBAction func backupButttonClicked(_ sender: Any) {
		let alert = UIAlertController(title: "백업 및 복구", message: nil, preferredStyle: .actionSheet)
		let backupAlert = UIAlertAction(title: "백업", style: .default) { _ in
			self.hud.show(in: self.view)
			self.backupProcess()
		}
		let restroeAlert = UIAlertAction(title: "복구", style: .default) { _ in
			self.restoreProcess()
		}
		let cancel = UIAlertAction(title: "취소", style: .cancel)
		
		alert.addAction(backupAlert)
		alert.addAction(restroeAlert)
		alert.addAction(cancel)
		
		present(alert, animated: true, completion: nil)
	}
	
	
	@IBAction func sortButtonClicked(_ sender: Any) {
		//시작할때 초기화를 안해주면 정렬을 선택할때마다 정렬의 기준들이 겹친다
		self.tasks = self.localRealm.objects(ShoppingList.self)
		
		let alert = UIAlertController(title: "정렬", message: "오와열!", preferredStyle: .actionSheet)
		//데이터를 일회성으로 소팅하는게 아니라 Results의 상태가 소팅을 지속하는 상태가 되는 것 같다.
		let checkBox = UIAlertAction(title: "안한 일", style: .default) { _ in
			self.tasks = self.tasks.filter("isCheck == false")
			self.tableView.reloadData()
		}
		let old = UIAlertAction(title: "오래된 순서", style: .default) { _ in
			self.tasks = self.tasks.sorted(byKeyPath: "createDate", ascending: true)
			self.tableView.reloadData()
		}
		let new = UIAlertAction(title: "최근 순서", style: .default) { _ in
			self.tasks = self.tasks.sorted(byKeyPath: "createDate", ascending: false)
			self.tableView.reloadData()
		}
		let star = UIAlertAction(title: "Star", style: .default) { _ in
			self.tasks = self.tasks.filter("isStar == true")
			self.tableView.reloadData()
		}
		let original = UIAlertAction(title: "원래대로", style: .default) { _ in
			self.tasks = self.localRealm.objects(ShoppingList.self)
			self.tableView.reloadData()
		}
		let cancel = UIAlertAction(title: "취소", style: .cancel)
		
		alert.addAction(checkBox)
		alert.addAction(old)
		alert.addAction(new)
		alert.addAction(star)
		alert.addAction(original)
		alert.addAction(cancel)
		
		present(alert, animated: true, completion: nil)
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
	
	func documentDirectoryPath() -> String? {
		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
		let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
		if let directoryPath = path.first {
			return directoryPath
		} else {
			return nil
		}
	}

	func presentActivityViewController() {
		let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
		let fileURL = URL(fileURLWithPath: fileName)
		
		let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
		self.present(vc, animated: true, completion: nil)
	}

	func backupProcess() {
	//	self.view.isUserInteractionEnabled = false //이걸 안넣어줘도 알아서 안눌린다.

		var urlPaths = [URL]()
		
		if let path = documentDirectoryPath() {
			let realm = (path as NSString).appendingPathComponent("default.realm")
			if FileManager.default.fileExists(atPath: realm) {
				urlPaths.append(URL(string: realm)!)
			} else {
				print("there is no file to backup")
			}
		}
		do {
			let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive")
			print("zip path: \(zipFilePath)")
			hud.dismiss(afterDelay: 1)
			presentActivityViewController()
		}
		catch {
			print("Something went wrong")
			hud.dismiss(afterDelay: 1)
		}
	//	self.view.isUserInteractionEnabled = true
	}

	func restoreProcess() {
		
		let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
		documentPicker.delegate = self
		documentPicker.allowsMultipleSelection = false
		self.present(documentPicker, animated: true) {
		}
		
	}

	
	
}

extension MainTableViewController: UIDocumentPickerDelegate {
	
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		print(#function)
	}
	
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		print(#function)
		
		guard let selectedFileUrl = urls.first else {return}
		
		let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let sandboxFileURL = directory.appendingPathComponent(selectedFileUrl.lastPathComponent)
		
		if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
			do {
				let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
				let fileURL = documentDirectory.appendingPathComponent("archive.zip")
				
				try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
					print("progress: \(progress)")
				}, fileOutputHandler: { unzippedFile in
					print("unzippedFile: \(unzippedFile)")
				})
			} catch {
				print("unzip ERROR")
			}
		} else {
			do {
				try FileManager.default.copyItem(at: selectedFileUrl, to: sandboxFileURL)
		
				let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
				let fileURL = documentDirectory.appendingPathComponent("archive.zip")
				
				try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
					print("progress: \(progress)")
				}, fileOutputHandler: { unzippedFile in
					print("unzippedFile: \(unzippedFile)")
				})
			} catch {
				print("unzip 2 ERROR")
			}
		}
		//restoreAlert의 클로져와 restoreProcess에 넣으면 주기가 안맞아서 그런지 안뜸
		let alert = UIAlertController(title: "재시작 필요함", message: nil, preferredStyle: .alert)
		let ok = UIAlertAction(title: "확인", style: .default) { _ in
			exit(0)
		}
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)

	}
	
	
}
