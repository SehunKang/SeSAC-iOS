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

public func tokenExpired(currentViewController: UIViewController) {
    let alert = UIAlertController(title: "로그인 세션 만료", message: "다시 로그인 해 주세요", preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인", style: .default) { action in
        DispatchQueue.main.async {
            pushCallBack(vc: currentViewController) { vc in
                vc.navigationController?.pushViewController(SignInViewController(), animated: false)
            }
        }
    }
    alert.addAction(ok)
    currentViewController.present(alert, animated: true, completion: nil)
}

// 더 좋은 방법이 없을까?
func pushCallBack(vc: UIViewController, completion: @escaping (UIViewController) -> ()) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    let rootViewController = InitialViewController()
    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: rootViewController)
    windowScene.windows.first?.makeKeyAndVisible()
    completion(rootViewController)
}
