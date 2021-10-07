//
//  DDayViewController.swift
//  SeSACEmotionDiary
//
//  Created by Sehun Kang on 2021/10/07.
//

import UIKit

class DDayViewController: UIViewController {

	@IBOutlet var datePicker: UIDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		if #available(iOS 14.0, *) {
			datePicker.preferredDatePickerStyle = .inline
		}
		
        // Do any additional setup after loading the view.
    }
    
	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		print(datePicker.date)
		print(sender.date)
		
		//DateFormatter: 1. DateFormat 2.timezone set
		let format = DateFormatter()
		format.dateFormat = "yy/MM/dd" //21/10/20
		let value = format.string(from: sender.date)
		print(value)
		//100일 뒤: TimeInterval, Calender
		let afterDate = Date(timeInterval: 86400 * 100, since: sender.date)
		print(afterDate)
	}
}
