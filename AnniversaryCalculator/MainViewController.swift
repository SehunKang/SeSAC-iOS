//
//  MainViewController.swift
//  AnniversaryCalculator
//
//  Created by Sehun Kang on 2021/10/07.
//

import UIKit

class MainViewController: UIViewController {

	
	@IBOutlet var oneHundredLabel: UILabel!
	@IBOutlet var twoHundredLabel: UILabel!
	@IBOutlet var threeHundredLabel: UILabel!
	@IBOutlet var fourHundredLabel: UILabel!
	@IBOutlet var mainDatePicker: UIDatePicker!
		
	override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 14.0, *) {
			mainDatePicker.preferredDatePickerStyle = .inline
		} else {
			mainDatePicker.preferredDatePickerStyle = .wheels
		}
		setAnniversary()
    }
	
	
	func setAnniversary() {
		let format = DateFormatter()
		format.dateFormat = "yyyy년\nMM월 dd일"
		oneHundredLabel.text = format.string(from: Date(timeInterval: 86400 * 100, since: mainDatePicker.date))
		
		twoHundredLabel.text = format.string(from: Date(timeInterval: 86400 * 200, since: mainDatePicker.date))
		
		threeHundredLabel.text = format.string(from: Date(timeInterval: 86400 * 300, since: mainDatePicker.date))
		
		fourHundredLabel.text = format.string(from: Date(timeInterval: 86400 * 400, since: mainDatePicker.date))
	}

    
	@IBAction func dateChanged(_ sender: UIDatePicker) {
		setAnniversary()
	}
	
}
