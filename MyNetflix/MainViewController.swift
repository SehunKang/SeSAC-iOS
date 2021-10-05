//
//  MainViewController.swift
//  MyNetflix
//
//  Created by Sehun Kang on 2021/09/29.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet var image1: UIImageView!
	@IBOutlet var image2: UIImageView!
	@IBOutlet var image3: UIImageView!
	@IBOutlet var image4: UIImageView!
	@IBOutlet var mainButton: UIButton!
	
	var imageArray: [UIImage] = [
		UIImage(named: "poster1")!,
		UIImage(named: "poster2")!,
		UIImage(named: "poster3")!,
		UIImage(named: "poster4")!,
		UIImage(named: "poster5")!,
		UIImage(named: "poster6")!,
		UIImage(named: "poster7")!,
		UIImage(named: "poster8")!,
		UIImage(named: "poster9")!,
		UIImage(named: "poster10")!
	]
	
	func arrayGenerator() -> [Int] {
		var arrayOfRandomNumber: [Int] = []
		var j = 0
		for i in 0...3 {
			arrayOfRandomNumber.append(Int.random(in: 0...9))
			while j < i {
				while arrayOfRandomNumber[i] == arrayOfRandomNumber[j] {
					arrayOfRandomNumber[i] = Int.random(in: 0...9)
				}
				j += 1
			}
			j = 0
		}
		return arrayOfRandomNumber
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		var arrayNum: [Int] = []
		arrayNum = arrayGenerator()
		image1.image = imageArray[arrayNum[0]]
		image2.image = imageArray[arrayNum[1]]
		image3.image = imageArray[arrayNum[2]]
		image4.image = imageArray[arrayNum[3]]
	}
	
	
	@IBAction func buttonClicked(_ sender: Any) {
		var arrayNum: [Int] = []
		arrayNum = arrayGenerator()
		image1.image = imageArray[arrayNum[0]]
		image2.image = imageArray[arrayNum[1]]
		image3.image = imageArray[arrayNum[2]]
		image4.image = imageArray[arrayNum[3]]
	}
	
	
}
