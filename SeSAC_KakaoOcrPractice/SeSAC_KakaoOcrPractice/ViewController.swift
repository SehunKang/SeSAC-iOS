//
//  ViewController.swift
//  SeSAC_KakaoOcrPractice
//
//  Created by Sehun Kang on 2021/10/30.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var imageButton: UIButton!
	@IBOutlet weak var getTextButton: UIButton!
	@IBOutlet weak var resultLabel: UILabel!
	
	
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.sourceType = .photoLibrary
		imageButton.setTitle("클릭하여 사진 첨부", for: .normal)
		
	}

	@IBAction func imageButtonClicked(_ sender: UIButton) {
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func getTextButtonClicked(_ sender: Any) {
		APIManager.shared.fetchTextData(image: image.image!) { code, json in
			if code == 200 {
				
				var text: String = ""
				for i in 0...json["result"].count {
					text.append(json["result"][i]["recognition_words"][0].stringValue)
					text.append(" ")
				}
				self.resultLabel.text = text
				print("text = \(text)")
			}
		}
	}
	
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let value = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			image.image = value
		}
		imageButton.titleLabel?.isHidden = true
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		print(#function)
	}
	
}
