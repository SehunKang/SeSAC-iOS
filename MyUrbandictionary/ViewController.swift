//
//  ViewController.swift
//  MyUrbandictionary
//
//  Created by Sehun Kang on 2021/10/02.
//

import UIKit

class ViewController: UIViewController {

	
	@IBOutlet var textField: UITextField!
	@IBOutlet var returnButton: UIButton!
	@IBOutlet var recommend1: UIButton!
	@IBOutlet var recommend2: UIButton!
	@IBOutlet var recommend3: UIButton!
	@IBOutlet var recommend4: UIButton!
	@IBOutlet var labelField: UILabel!
	

	
	var MyUrbanDictionary: [String: String] = ["jmt": "존맛탱(존나맛있다)", "꾸안꾸": "꾸민듯 안꾸민듯", "네이스": "나이스", "엄카": "엄마카드", "잼민이": "어린이", "창렬하다": "가격에 비해 내용물이 부실하다"]

	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		labelField.adjustsFontSizeToFitWidth = true
		textField.borderStyle = .line
		textField.attributedPlaceholder = NSAttributedString(string: "단어를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
		textField.textColor = .black
		textField.layer.borderWidth = 1.5
		returnButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
		recommendButtonSet()
	}
	
	func recommendButtonSet() {
		let buttons: [UIButton] = [recommend1, recommend2, recommend3, recommend4]
		let textAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 10)]
		var randomStringFromDictionary: [String] = Array(MyUrbanDictionary.keys).shuffled()
		for element in buttons {
			element.setAttributedTitle(NSAttributedString(string: randomStringFromDictionary[0], attributes: textAttribute), for: .normal)
			element.layer.cornerRadius = 5.0
			element.layer.borderWidth = 1.0
			randomStringFromDictionary.removeFirst()
		}
	}

	@IBAction func tapBackground(_ sender: UIGestureRecognizer) {
		if textField.isFirstResponder == true {
			view.endEditing(true)
		}
	}
	
	@IBAction func recommendButtonPressed(_ sender: UIButton) {
		textField.text = (sender.currentAttributedTitle?.string)!
		returnPressed(textField)
	}
	
	@IBAction func returnButtonPressed(_ sender: UIButton) {
		returnPressed(textField)
		if textField.isFirstResponder == true {
			view.endEditing(true)
		}
	}
	
	@IBAction func returnPressed(_ sender: UITextField) {
		if MyUrbanDictionary[textField.text!] != nil {
			labelField.text = MyUrbanDictionary[textField.text!]
		} else {
			labelField.text = "단어가 없습니다."
		}
		recommendButtonSet()
	}
	
	
	
	

}

