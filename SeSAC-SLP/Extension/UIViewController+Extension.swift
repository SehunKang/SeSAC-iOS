//
//  ViewController+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/20.
//

import Foundation
import UIKit

extension UIViewController {
        
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func internetCheck() {
        if !Connectivity.isConnectedToInternet {
            easyAlert(vc: self, title: "네트워크 오류", message: "인터넷에 연결되어있지 않습니다.")
        }
    }
}
