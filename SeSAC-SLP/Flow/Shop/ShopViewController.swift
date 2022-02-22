//
//  ShopViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import UIKit

class ShopViewController: UIViewController {
    
    var foregroundImage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(foregroundClicked(_:)), name: NSNotification.Name("foregroundClicked"), object: nil)
    }
    
    @objc func foregroundClicked(_ notification: Notification) {
        guard let item = notification.userInfo?["item"] as? Int else {return}
        foregroundImage = item
    }


}
