//
//  Extension.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation
import UIKit

extension String {

    func dateFormat() -> String? {
        let date2 = self

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: date2) {
            let format = DateFormatter()
            format.dateFormat = "MM/dd"
            return format.string(from: date)
        }
        return nil
    }
}

extension UIViewController {
    
    public func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(self, animated: true, completion: nil)
    }
    
    func tokenExpired() {
        let alert = UIAlertController(title: "로그인 세션 만료", message: "다시 로그인 해 주세요", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            DispatchQueue.main.async {
                pushCallBack(vc: self) { vc in
                    vc.navigationController?.pushViewController(SignInViewController(), animated: false)
                }
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

public func pushCallBack(vc: UIViewController, completion: @escaping (UIViewController) -> ()) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    let rootViewController = InitialViewController()
    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: rootViewController)
    windowScene.windows.first?.makeKeyAndVisible()
    completion(rootViewController)
}

public func popCallBack(from vc: UIViewController, completion: @escaping () -> ()) {
    vc.navigationController?.popViewController(animated: true)
    completion()
}
