//
//  SignUpViewController.swift
//  MyNetflix
//
//  Created by Sehun Kang on 2021/09/30.
//

import UIKit

class SignUpViewController: UIViewController {
	
	@IBOutlet var textField1: UITextField!
	@IBOutlet var textField2: UITextField!
	@IBOutlet var textField3: UITextField!
	@IBOutlet var textField4: UITextField!
	@IBOutlet var textField5: UITextField!
	
	@IBOutlet var signupButton: UIButton!
	
	@IBOutlet var infoSwitch: UISwitch!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		textField1.backgroundColor = UIColor.darkGray
		textField1.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		textField1.textColor = UIColor.white
		textField1.keyboardAppearance = .default
		textField1.isSecureTextEntry = false
		textField1.textAlignment = NSTextAlignment.center
		
		textField2.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		textField2.textColor = UIColor.white
		textField2.keyboardType = UIKeyboardType.default
		textField2.isSecureTextEntry = true
		textField2.textAlignment = NSTextAlignment.center
		
		textField3.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		textField3.textColor = UIColor.white
		textField3.keyboardType = UIKeyboardType.default
		textField3.isSecureTextEntry = false
		textField3.textAlignment = NSTextAlignment.center
		textField3.isHidden = false
		
		textField4.attributedPlaceholder = NSAttributedString(string: "위치", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		textField4.textColor = UIColor.white
		textField4.keyboardType = UIKeyboardType.default
		textField4.isSecureTextEntry = false
		textField4.textAlignment = NSTextAlignment.center
		textField4.isHidden = false
		
		textField5.attributedPlaceholder = NSAttributedString(string: "추천 코드 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		textField5.textColor = UIColor.white
		textField5.keyboardType = UIKeyboardType.default
		textField5.isSecureTextEntry = false
		textField5.textAlignment = NSTextAlignment.center
		textField5.isHidden = false
		
		signupButton.tintColor = .white
		signupButton.setTitle("회원가입", for: UIControl.State.normal
		)
		signupButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
		
		infoSwitch.setOn(true, animated: true)
		infoSwitch.onTintColor = UIColor.systemRed
		infoSwitch.thumbTintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
	@IBAction func switchAction(_ sender: Any) {
		if !infoSwitch.isOn {
			textField3.isHidden = true
			textField4.isHidden = true
			textField5.isHidden = true
		} else {
			textField3.isHidden = false
			textField4.isHidden = false
			textField5.isHidden = false
		}
	}
	
	@IBAction func printTexts(_ sender: UIButton) {
		print(textField1.text!)
		print(textField2.text!)
		print(textField3.text!)
		print(textField4.text!)
		print(textField5.text!)
	}
	
	@IBAction func tapClicked(_ sender: UITapGestureRecognizer) {
		view.endEditing(true)
	}

	
}
