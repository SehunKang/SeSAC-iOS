//
//  ViewController+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/20.
//

import UIKit
import FirebaseAuth
import Toast

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
    
    func navBarBackButtonConfigure() {
        let image = UIImage(named: "arrow")
        self.navigationController?.navigationBar.tintColor = CustomColor.SLPBlack.color
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func goHome() {
        let mainSb = UIStoryboard(name: "Main", bundle: nil)
        let mainVc = mainSb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let mainNav = UINavigationController(rootViewController: mainVc)
        
        let infoSb = UIStoryboard(name: "MyInfo", bundle: nil)
        let infoVc = infoSb.instantiateViewController(withIdentifier: MyInfoViewController.identifier) as! MyInfoViewController
        let infoNav = UINavigationController(rootViewController: infoVc)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [mainNav, infoNav]
        
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    func refreshToken(completion: @escaping () -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                self.view.makeToast("오류가 발생했습니다. 잠시후에 다시 시도해주세요")
                print(error.localizedDescription)
                return
            }
            UserDefaultManager.idtoken = idToken!
            completion()
        }
    }
    
    func errorHandler(with code: Int) {
        switch code {
        case 406:
            self.view.makeToast("가입되지 않은 회원입니다.", duration: 1, style: ToastManager.shared.style) { didTap in
                let sb = UIStoryboard(name: "Start", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: PhoneAuthViewController.identifier) as! PhoneAuthViewController
                let nav = UINavigationController(rootViewController: vc)
                self.view.window?.rootViewController = nav
                self.view.window?.makeKeyAndVisible()
            }
        case 500:
            self.view.makeToast("서버에 에러가 생겼습니다.\n잠시후에 다시 시도해주세요")
        case 501:
            self.view.makeToast("Client ERROR!")
        default:
            self.view.makeToast("알수없는 에러")
        }
    }
    
}
