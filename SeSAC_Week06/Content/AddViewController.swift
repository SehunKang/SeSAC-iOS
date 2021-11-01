//
//  AddViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/01.
//

import UIKit

class AddViewController: UIViewController {

	static let identifier = "AddViewController"
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var dateButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	
	
	@IBOutlet weak var contentNavigationBar: UINavigationBar!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setContentNavigaionBar()
		
    }
	
	func setContentNavigaionBar() {
		let navigationItem = UINavigationItem(title: LocalizableStrings.content_title.localized)
		let leftItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: #selector(goBackToMain(_:)))
		let rightItem = UIBarButtonItem(title: LocalizableStrings.save.localized, style: .plain, target: nil, action: nil)
		navigationItem.leftBarButtonItem = leftItem
		navigationItem.rightBarButtonItem = rightItem
		contentNavigationBar.setItems([navigationItem], animated: false)
	}
	
	@objc func goBackToMain(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

}
