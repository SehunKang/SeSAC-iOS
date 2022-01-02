//
//  SignInViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//
//
import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    let mainView = SignInView()
    
    let viewModel = SignInViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelBind()
        targetConfig()
    }
    
    @objc private func requestSignIn() {
        
        viewModel.postSignIn { error in
            if let error = error {
                let alert = UIAlertController(title: "오류", message: "잘못된 로그인 정보입니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainPostViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }

    private func targetConfig() {
        mainView.signInField.emailField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: .editingChanged)
        mainView.signInField.passwordField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: .editingChanged)
        mainView.signInField.confirmButton.addTarget(self, action: #selector(requestSignIn), for: .touchUpInside)

    }
    
    private func modelBind() {
        viewModel.email.bind { text in
            self.mainView.signInField.emailField.text = text
        }
        viewModel.password.bind { text in
            self.mainView.signInField.passwordField.text = text
        }
        
    }
    
    @objc private func emailFieldDidChange(_ textField: UITextField) {
        viewModel.email.value = textField.text ?? ""
    }
    @objc private func passwordFieldDidChange(_ textField: UITextField) {
        viewModel.password.value = textField.text ?? ""
    }

    
    
}
