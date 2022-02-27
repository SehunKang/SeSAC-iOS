//
//  ProfileViewController.swift
//  DrinkWater
//
//  Created by Sehun Kang on 2021/10/08.
//

import UIKit
import TextFieldEffects

class ProfileViewController: UIViewController {

	@IBOutlet var backGroundViewForProfile: UIView!
	@IBOutlet var cactusImage: UIImageView!
	@IBOutlet var labelName: UILabel!
	@IBOutlet var textName: UITextField!
	@IBOutlet var labelHeight: UILabel!
	@IBOutlet var textHeight: UITextField!
	@IBOutlet var labelWeight: UILabel!
	@IBOutlet var textWeight: UITextField!
	@IBOutlet var navigationBar: UINavigationItem!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		backGroundViewForProfile.backgroundColor = .init(red: 0x4c / 255, green: 0x94 / 255, blue: 0x71 / 255, alpha: 1)
		cactusImage.image = UIImage(named: "8")
		textFieldSet()
		labelSet()
		self.navigationController?.navigationBar.tintColor = UIColor.white
		navigationBar.rightBarButtonItem?.title = "저장"
	}
	
	func labelSet() {
		labelName.text = "닉네임을 설정해주세요"
		labelName.textColor = .white
		labelName.font = .systemFont(ofSize: 13)
		labelHeight.text = "키(cm)를 설정해주세요"
		labelHeight.textColor = .white
		labelHeight.font = .systemFont(ofSize: 13)
		labelWeight.text = "몸무게(kg)를 설정해주세요"
		labelWeight.textColor = .white
		labelWeight.font = .systemFont(ofSize: 13)
	}
    	
	func textFieldSet() {
		detailedTextFieldSet(sender: textName)
		detailedTextFieldSet(sender: textHeight)
		detailedTextFieldSet(sender: textWeight)
	}
	
	func detailedTextFieldSet(sender: UITextField) {
		sender.borderStyle = .none
		let border = CALayer()
		border.frame = CGRect(x: 0, y: sender.frame.size.height - 1, width: sender.frame.width, height: 1)
		border.backgroundColor = UIColor.white.cgColor
		sender.layer.addSublayer((border))
		sender.textColor = .white
		sender.font = .systemFont(ofSize: 20)
	}
	

	@IBAction func saveTouched(_ sender: UIBarButtonItem) {
		let recommend: Double
		let heightValue = Double(textHeight.text!)
		let weightValue = Double(textWeight.text!)
		let alert = UIAlertController(title: "어랏?!", message: "입력하신 내용을 다시한번 확인해주세요", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "알겠습니다", style: .default) { (action) in}
		alert.addAction(alertAction)
		if heightValue == nil || weightValue == nil || textName.text == nil {
			present(alert, animated: false, completion: nil)
		} else {
			recommend = round((heightValue! + weightValue!) / 10) / 10
			UserDefaults.standard.set(textName.text, forKey: "userName")
			UserDefaults.standard.set(recommend, forKey: "goal")
			UserDefaults.standard.set(0, forKey: "sofar")
		}
	}
	
	@IBAction func backgroundTouched(_ sender: Any) {
		view.endEditing(true)
	}
	

}
