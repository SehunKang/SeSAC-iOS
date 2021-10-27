//
//  MainViewController.swift
//  LottoProject
//
//  Created by Sehun Kang on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {

	@IBOutlet var drwLabels: [UILabel]!
	@IBOutlet weak var plusLabel: UILabel!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var guideLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var drwnoLabel: UILabel!
	@IBOutlet weak var pickerView: UIPickerView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		pickerView.delegate = self
		pickerView.dataSource = self
		pickerView.isHidden = true
		pickerView.selectRow(getCurrentRound() - 1, inComponent: 0, animated: false)
		
		topTextField.delegate = self
		topTextField.inputView = pickerView
		
		plusLabel.textAlignment = .center
		plusLabel.text = "+"
		guideLabel.text = "당첨번호 안내"
		drwnoLabel.textAlignment = .center
		drwnoLabel.font = .systemFont(ofSize: 30)
		topTextField.text = "\(getCurrentRound())"
		getLotto(getCurrentRound())
		
		for i in 0...(drwLabels.count - 1) {
			drwLabels[i].textColor = .black
			drwLabels[i].textAlignment = .center
			drwLabels[i].layer.cornerRadius = drwLabels[i].frame.width / 2
			drwLabels[i].layer.masksToBounds = true
		}
    }

	func getCurrentRound() -> Int {
		var tv = timeval()
		gettimeofday(&tv, nil)
		//((1970.1.1 ~ now) - (1970.1.1 ~ 2002.12.7)) / week + 1
		return ((tv.tv_sec - 1039132800) / 604800) + 1
	}

	
	func getLotto(_ round: Int) {
		let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
		AF.request(url, method: .get).validate().responseJSON { response in
			switch response.result {
			case .success(let value):
				print(JSON(value))
				self.setLabelNumber(json: JSON(value))
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func setLabelNumber(json: JSON) {
		for i in 0...drwLabels.count - 2 {
			drwLabels[i].text = String(json["drwtNo\(i + 1)"].intValue)
		}
		drwLabels[6].text = String(json["bnusNo"].intValue)
		dateLabel.text = "\(json["drwNoDate"].stringValue) 추첨"
		drwnoLabel.text = "\(json["drwNo"].stringValue)회 당첨결과"
		setNumcolor()
	}
	
	func setNumcolor() {
		for i in 0...(drwLabels.count - 1) {
			let value = Int(drwLabels[i].text!)
			switch value! {
			case 1...9:
				drwLabels[i].backgroundColor = .systemOrange
			case 10...19:
				drwLabels[i].backgroundColor = .systemBlue
			case 20...29:
				drwLabels[i].backgroundColor = .systemRed
			case 30...45:
				drwLabels[i].backgroundColor = .systemGray
			default:
				drwLabels[i].backgroundColor = .systemRed
			}
		}
	}
}


extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return getCurrentRound()
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "\(row + 1)"
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.topTextField.text = "\(row + 1)"
		getLotto(row + 1)
		pickerView.isHidden = true
	}
}

extension MainViewController: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		pickerView.isHidden = false
		return false
	}
}
