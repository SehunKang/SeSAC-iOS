//
//  ViewController.swift
//  LEDBoard
//
//  Created by Sehun Kang on 2021/10/01.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var topView: UIView!
	
	@IBOutlet var mainBoardText: UILabel!
	
	@IBOutlet var textInputArea: UITextField!
	
	@IBOutlet var sendButton: UIButton!
	
	@IBOutlet var fontButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		topView.layer.cornerRadius = 5
		topView.backgroundColor = UIColor.white
		
		textInputArea.attributedPlaceholder = NSAttributedString(string: "텍스트를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])

		sendButton.setTitle("보내기", for: .normal)
		sendButton.setTitleColor(UIColor.black, for: .normal)
		fontButton.setTitle("Aa", for: .normal)
		fontButton.setTitleColor(UIColor.systemRed, for: .normal)
		mainBoardText.textColor = .white
		mainBoardText.adjustsFontSizeToFitWidth = true

	}
	
	@IBAction func sendText(_ sender: UIButton) {
		returnPressed(textInputArea)
		view.endEditing(true)
	}
	
	@IBAction func returnPressed(_ sender: UITextField) {
		mainBoardText.text = textInputArea.text
		textInputArea.text = nil
	}
	
	@IBAction func fontChange(_ sender: UIButton) {
		mainBoardText.textColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
	}
	
	@IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
		if textInputArea.isFirstResponder == true {
			view.endEditing(true)
		} else {
			if topView.isHidden == false {
				topView.isHidden = true
			} else {
				topView.isHidden = false
			}
		}
	}
	
}

