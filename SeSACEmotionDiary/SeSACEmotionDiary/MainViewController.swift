//
//  MainViewController.swift
//  SeSACEmotionDiary
//
//  Created by Sehun Kang on 2021/10/06.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet var collectionLabel:[UILabel]!
	@IBOutlet var collectionButton: [UIButton]!
	
	@IBOutlet var happyLable: UILabel!
	@IBOutlet var crazyLabel: UILabel!
	@IBOutlet var loveitLabel: UILabel!
	@IBOutlet var angryLabel: UILabel!
	@IBOutlet var sadLabel: UILabel!
	@IBOutlet var badLabel: UILabel!
	@IBOutlet var frustratedLabel: UILabel!
	@IBOutlet var sleepyLabel: UILabel!
	@IBOutlet var boredLabel: UILabel!
		
	@IBOutlet var happyButton: UIButton!
	@IBOutlet var crazyButton: UIButton!
	@IBOutlet var loveitButton: UIButton!
	@IBOutlet var angryButton: UIButton!
	@IBOutlet var sleepyButton: UIButton!
	@IBOutlet var frustratedButton: UIButton!
	@IBOutlet var badButton: UIButton!
	@IBOutlet var sadButton: UIButton!
	@IBOutlet var boredButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		let emojiDescription = ["별로야", "지루해", "이상해", "최고야", "행복해", "신난다", "슬퍼", "화나", "헐랭"]
		for i in 0...8 {
			var num = UserDefaults.standard.integer(forKey: emojiDescription[i])
			if num > 999 {
				num = 999
			}
			collectionLabel[i].text = "\(emojiDescription[i]) \(num)"
			collectionButton[i].setAttributedTitle(NSAttributedString(string: emojiDescription[i], attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear]), for: .normal)
		}
	}
	
	@IBAction func resetButton(_ sender: UIButton) {
		
		for element in collectionButton {
			UserDefaults.standard.set(0, forKey: (element.titleLabel?.text)!)
		}
		viewDidLoad()
	}
	
	//각 버튼과 레이블의 타이틀을 똑같이 만들어서 userdefaults의 forkey값으로 사용했다.
	@IBAction func buttonClicked(_ sender: UIButton) {
		
		let num = UserDefaults.standard.integer(forKey: (sender.titleLabel?.text)!)
		
		UserDefaults.standard.set(num + 1, forKey: (sender.titleLabel?.text)!)
		viewDidLoad()
	}
}

