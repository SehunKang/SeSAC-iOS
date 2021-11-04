//
//  AddViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

	let localRealm = try! Realm()
	
	static let identifier = "AddViewController"
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var dateButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var imageLoadButton: UIButton!
	
	
	@IBOutlet weak var contentNavigationBar: UINavigationBar!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		imageLoadButton.setTitle("클릭하여 이미지 업로드", for: .normal)
		setContentNavigaionBar()
		
		print("realm is located at:", localRealm.configuration.fileURL!)
    }
	
	
	func setContentNavigaionBar() {
		let navigationItem = UINavigationItem(title: LocalizableStrings.content_title.localized)
		let leftItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: #selector(goBackToMain(_:)))
		let rightItem = UIBarButtonItem(title: LocalizableStrings.save.localized, style: .plain, target: nil, action: #selector(saveButtonClicekd(_:)))
		navigationItem.leftBarButtonItem = leftItem
		navigationItem.rightBarButtonItem = rightItem
		contentNavigationBar.setItems([navigationItem], animated: false)
	}
	
	@objc func goBackToMain(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func imageLoadButtonClicked(_ sender: Any) {
		let alert = UIAlertController(title: "어떤 이미지?", message: nil, preferredStyle: .actionSheet)
		let camera = UIAlertAction(title: "Camera", style: .default) { _ in
			self.openCamera()
		}
		let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
			self.openGallery()
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(camera)
		alert.addAction(gallery)
		alert.addAction(cancel)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func openCamera() {
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let picker = UIImagePickerController()
			picker.delegate = self
			picker.sourceType = .camera
			picker.allowsEditing = false
			self.present(picker, animated: true, completion: nil)
		} else {
			print("No Permission")
		}
	}
	
	func openGallery() {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let picker = UIImagePickerController()
			picker.delegate = self
			picker.allowsEditing = true
			picker.sourceType = .photoLibrary
			self.present(picker, animated: true, completion: nil)
		} else {
			print("Gallery permission")
		}
	}
	
	@objc func saveButtonClicekd(_ sender: UIBarButtonItem) {
		self.view.isUserInteractionEnabled = false // alert을 넣어서 없어도 될것 같지만 혹시 모르니..
		let task = UserDiary(diaryTitle: textField.text!, diaryText: textView.text!, writeDate: Date(), registerDate: Date())
		try! localRealm.write {
			localRealm.add(task)
			//이미지 저장 조건처리
			if imageView.image != nil {
				saveImageToDocumentDirectory(imageName: "\(task._id).jpg", image: imageView.image!)
			}
		}
		let alert = UIAlertController(title: "저장 완료!", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.view.isUserInteractionEnabled = true
		self.present(alert, animated: true, completion: nil)

	}
	
	func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
		//1. 이미지 저장할 경로 설정: 도큐먼트 폴더(.documentDirectory), FileManager
		//ex. Desktop/jack/ios/foler
		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		
		//2. 이미지 파일 이름
		//ex. Desktop/jack/ios/filder/222.png
		let imageURL = documentDirectory.appendingPathComponent(imageName)
		
		//3. 이미지 압축 (image.pngData or jpegData(compressionQuality: )
		guard let data = image.jpegData(compressionQuality: 0.5) else { return }
		
		//4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우
		//4-1. 이미지 경로 여부 확인
		if FileManager.default.fileExists(atPath: imageURL.path) {
			
			//4-2. 기존 경로에 있는 이미지 삭제
			do {
				try FileManager.default.removeItem(at: imageURL)
				print("image deleted")
			} catch {
				print("error")
			}
		}
		//5. 이미지를 도큐먼트에 저장
		do {
			try data.write(to: imageURL)
		} catch {
			print("error")
		}
	}
	
	

}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		if let value = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			imageView.image = value
		}
		imageLoadButton.titleLabel?.isHidden = true
		picker.dismiss(animated: true, completion: nil)
	}
	
}
