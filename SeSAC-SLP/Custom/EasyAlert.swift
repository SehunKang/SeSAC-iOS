//
//  CustomAlert.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/19.
//

import Foundation
import UIKit

public func easyAlert(vc: UIViewController, title: String, message: String) {
    
    
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.view.tintColor = CustomColor.SLPBlack.color
    
    alert.addAction(ok)
    vc.present(alert, animated: true, completion: nil)
}
