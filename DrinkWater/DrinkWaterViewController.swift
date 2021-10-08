//
//  DrinkWaterViewController.swift
//  DrinkWater
//
//  Created by Sehun Kang on 2021/10/08.
//

import UIKit

class DrinkWaterViewController: UIViewController {

	@IBOutlet var backgroundView: UIView!
	@IBOutlet var cactusImage: UIImageView!
	@IBOutlet var drinkButton: UIButton!
	@IBOutlet var profileButton: UIBarButtonItem!
	@IBOutlet var resetButton: UIBarButtonItem!
	@IBOutlet var labelTop: UILabel!
	@IBOutlet var labelMid: UILabel!
	@IBOutlet var labelBottom: UILabel!
	@IBOutlet var mainNavigationItem: UINavigationItem!
	@IBOutlet var labelWaterHundred: UILabel!
	@IBOutlet var labelWaterTwoHundred: UILabel!
	@IBOutlet var labelWaterFiveHundred: UILabel!
	@IBOutlet var labelRecommend: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		backgroundView.backgroundColor = .init(red: 0x4c / 255, green: 0x94 / 255, blue: 0x71 / 255, alpha: 1)
		
		mainViewSet()
    }
    
	func mainViewSet() {
		labelSet()
		imageSet()
		buttonSet()
	}
	
	func labelSet() {
		
		let sofar = UserDefaults.standard.double(forKey: "sofar")
		let goal = UserDefaults.standard.double(forKey: "goal")
		let userName = UserDefaults.standard.string(forKey: "userName")

		
		labelTop.text = "잘하셨어요!\n오늘 마신 양은"
		labelTop.font = UIFont.systemFont(ofSize: 25.0)
		labelTop.textColor = .white
		labelBottom.text = goal != 0 ? "목표의 \(Int(round(sofar / (goal * 1000) * 100)))%" : "목표의 0%"
		labelBottom.font = .systemFont(ofSize: 15)
		labelBottom.textColor = .white
		labelMid.text = "\(Int(sofar))ml"
		labelMid.font = .boldSystemFont(ofSize: 30)
		labelMid.textColor = sofar > goal * 1000 ? .systemRed : .white
		
		labelWaterHundred.text = "100ml"
		labelWaterHundred.font = .systemFont(ofSize: 17)
		labelWaterHundred.textColor = .white
		labelWaterTwoHundred.text = "200ml"
		labelWaterTwoHundred.font = .systemFont(ofSize: 17)
		labelWaterTwoHundred.textColor = .white
		labelWaterFiveHundred.text = "500ml"
		labelWaterFiveHundred.font = .systemFont(ofSize: 17)
		labelWaterFiveHundred.textColor = .white
		
		labelRecommend.text = "\(userName ?? "sehun")님의 하루 물 권장 섭취량은 \(goal)L 입니다."
		labelRecommend.font = .systemFont(ofSize: 15)
		labelRecommend.textColor = .white
	}
	
	func imageSet() {
		
		let sofar = UserDefaults.standard.double(forKey: "sofar")
		let goal = UserDefaults.standard.double(forKey: "goal") * 1000
		let sofarDivideGoal = Double(goal != 0 ? sofar / goal : 0)
		let image = Int(sofarDivideGoal * 8) > 8 ? 8 : Int(sofarDivideGoal * 8)
		cactusImage.image = UIImage(named: "\(image)")
	}
	
	
	func buttonSet() {
		let textStyleForButton: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 25)]
		drinkButton.setAttributedTitle(NSAttributedString(string: "물마시기", attributes: textStyleForButton), for: .normal)
		profileButton.image = UIImage(systemName: "person.circle")
		profileButton.tintColor = .white
		resetButton.image = UIImage(systemName: "arrow.clockwise")
		resetButton.tintColor = .white
		mainNavigationItem.title = "물 마시기"
	}

	func waterButtonTouched(sender: Double) {
		let sofar = UserDefaults.standard.double(forKey: "sofar")
		UserDefaults.standard.set(sofar + sender, forKey: "sofar")
		viewDidLoad()
	}
	
	@IBAction func waterHundredTouched(_ sender: UIButton) {
		waterButtonTouched(sender: 100)
	}
	
	@IBAction func waterTwoHundredTouched(_ sender: UIButton) {
		waterButtonTouched(sender: 200)
	}
	
	@IBAction func waterFiveHundredTouched(_ sender: UIButton) {
		waterButtonTouched(sender: 500)
	}
	
	@IBAction func resetButtonTouched(_ sender: UIBarButtonItem) {
		UserDefaults.standard.set(0, forKey: "sofar")
		viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		mainViewSet()
	}
	
}
