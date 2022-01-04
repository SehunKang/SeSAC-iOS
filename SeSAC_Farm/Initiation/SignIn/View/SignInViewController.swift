//
//  SignInViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//
//
import Foundation
import UIKit
import SimpleCheckbox


class SignInViewController: UIViewController {
    
    let mainView = SignInView()
    
    let viewModel = SignInViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkSaved()
        
        modelBind()
        targetConfig()
    }
    
    private func checkSaved() {
        print(UserDefaults.standard.string(forKey: "email"))
        print(UserDefaults.standard.string(forKey: "password"))
        if let savedEmail = UserDefaults.standard.string(forKey: "email"), let savedPass = UserDefaults.standard.string(forKey: "password") {
            self.viewModel.email.value = savedEmail
            self.viewModel.password.value = savedPass
            self.viewModel.check.value = true
        } else {
            return
        }
    }

    private func targetConfig() {
        
        mainView.signInField.emailField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: .editingChanged)
        mainView.signInField.passwordField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: .editingChanged)
        mainView.signInField.confirmButton.addTarget(self, action: #selector(requestSignIn), for: .touchUpInside)
        mainView.checkBox.addTarget(self, action: #selector(checkBoxValueChanged(_:)), for: .valueChanged)
    }
    
    private func modelBind() {
        
        viewModel.email.bind { text in
            self.mainView.signInField.emailField.text = text
        }
        viewModel.password.bind { text in
            self.mainView.signInField.passwordField.text = text
        }
        viewModel.check.bind { bool in
            self.mainView.checkBox.isChecked = bool
        }
    }
    
    @objc private func emailFieldDidChange(_ textField: UITextField) {
        viewModel.email.value = textField.text ?? ""
    }
    
    @objc private func passwordFieldDidChange(_ textField: UITextField) {
        viewModel.password.value = textField.text ?? ""
    }
    
    @objc private func checkBoxValueChanged(_ sender: Checkbox) {
        viewModel.check.value = sender.isChecked
    }

    @objc private func requestSignIn() {
        
        viewModel.postSignIn { error in
            if error != nil {
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
}
