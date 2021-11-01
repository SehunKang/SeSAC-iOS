//
//  HomeViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {
	
	static let identifier = "HomeViewController"
	
	@IBOutlet weak var mainNavigationBar: UINavigationBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setMainNavigationBar()
		// Do any additional setup after loading the view.
		
		
		//BMJUAOTF
//		welcomeLabel.text = LocalizableStrings.welcome_text.localized
//		welcomeLabel.font = UIFont().mainBlack
//
//		backupRestoreLabel.text = LocalizableStrings.data_backup.localizedSetting
		
	}
	
	func setMainNavigationBar() {
		//storyboard에서 object를 추가하지 않고 직접 UINavigationBar를 설정하니 safearea를 무시하고 레이아웃이 지정되어 수정함
		let navigationItem = UINavigationItem(title: "HOME")
		let navigationBarRightItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: #selector(plusButtonClicked(_:)))
		navigationItem.rightBarButtonItem = navigationBarRightItem
		mainNavigationBar.setItems([navigationItem], animated: false)
	}
	
	@objc func plusButtonClicked(_ sender: UIBarButtonItem) {
		let sb = UIStoryboard(name: "Content", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: AddViewController.identifier) as! AddViewController
		vc.modalPresentationStyle = .fullScreen
		self.present(vc, animated: true, completion: nil)
		
	}
}
