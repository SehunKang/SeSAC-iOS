//
//  WriteViewController.swift
//  SeSAC_MyMemoApp
//
//  Created by Sehun Kang on 2021/11/10.
//

import UIKit
import RealmSwift

//흰색글씨가 자연스럽게 안써진다. 다크모드 없이 억지로 다크모드를 시도한 패착, 그래서 write뷰는 흰색배경이다
class WriteViewController: UIViewController {
	
	static let identifier = "WriteViewController"
	
	@IBOutlet weak var textView: UITextView!
	
	let realm = try! Realm()
	var task = UserMemo()
	var id = ObjectId()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		textView.delegate = self
		task = realm.object(ofType: UserMemo.self, forPrimaryKey: id)!
		
		navigationItem.largeTitleDisplayMode = .never
		
		setNavItem()
		setDefaultText()
		textView.becomeFirstResponder()
		textView.textColor = .label


	}
//	viewWillDisappear에서 하면 더 깔끔한데 현재 로직에선 스와이프로 뒤로 갈랑말랑 하면 에러가 생김
//	override func viewWillDisappear(_ animated: Bool) {
//		super.viewWillDisappear(animated)
//
//		saveText()
//		print("disappear")
//	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		saveText()
		print("disappear")

	}
    
	func setNavItem() {
		let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: #selector(shareButtonClicked))
		let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: #selector(doneButtonClicked))
		navigationItem.setRightBarButtonItems([doneButton, shareButton], animated: true)
	}
	
	func setDefaultText() {
		let attributedTitle = NSMutableAttributedString(string: task.memoTitle ?? "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40)])
		let attributedText = NSMutableAttributedString(string: task.memoText ?? "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
		let combination = NSMutableAttributedString()
		combination.append(attributedTitle)
		combination.append(attributedText)
		textView.attributedText = combination
	}
	
	@objc func shareButtonClicked() {
		let vc = UIActivityViewController(activityItems: [ Realm.Configuration.defaultConfiguration.fileURL as Any], applicationActivities: [])
		self.present(vc, animated: true, completion: nil)
	}
	
	@objc func doneButtonClicked() {
		saveText()
	}

	func saveText() {
		if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			try! realm.write {
				realm.delete(task)
			}
		} else if let index = textView.text.range(of: "\n")?.lowerBound {
			let title = String(textView.text[...index])
			let plusOne = textView.text.index(index, offsetBy: 1)
			let text = String(textView.text[plusOne...])
			try! realm.write {
				task.memoTitle = title
				task.memoText = text
				task.memoOriginalText = textView.text
				task.memoEditedDate = Date()
			}
		} else if let title = textView.text {
			try! realm.write {
				task.memoTitle = title
				task.memoText = ""
				task.memoOriginalText = textView.text
				task.memoEditedDate = Date()
			}
		}
		
	}
}

extension WriteViewController: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let textAsNSString = textView.text as NSString
		let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
		let boldRange = replaced.range(of: "\n")
		if boldRange.location > range.location {
			textView.typingAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40), NSAttributedString.Key.foregroundColor: UIColor.label]
		} else {
			textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.label]
		}
		
		return true
	}
}

