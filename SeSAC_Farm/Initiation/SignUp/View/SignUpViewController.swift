//
//  File.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let mainView = SignUpView()
    
    let viewModel = SignUpViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새싹농장 가입하기"
        
        modelBind()
        targetConfig()
    }
    
    @objc private func requestSignUp() {
        
        viewModel.postSignUp { error in
            if let error = error {
                let alert = UIAlertController(title: "오류", message: "이미 존재하는 아이디 혹은 이메일입니다.", preferredStyle: .alert)
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
        mainView.signUpField.nickNameField.addTarget(self, action: #selector(nickNameFieldDidChange(_:)), for: .editingChanged)
        mainView.signUpField.emailField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: .editingChanged)
        mainView.signUpField.passwordField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: .editingChanged)
        mainView.signUpField.passwordCheck.addTarget(self, action: #selector(passwordCheckFieldDidChange(_:)), for: .editingChanged)
        mainView.signUpField.confirmButton.addTarget(self, action: #selector(requestSignUp), for: .touchUpInside)
    }
    
    
    private func modelBind() {
        viewModel.nickName.bind { text in
            self.mainView.signUpField.nickNameField.text = text
        }
        viewModel.email.bind { text in
            self.mainView.signUpField.emailField.text = text
        }
        viewModel.password.bind { text in
            self.mainView.signUpField.passwordField.text = text
        }
        viewModel.passwordCheck.bind { text in
            self.mainView.signUpField.passwordCheck.text = text
        }
    }
    
    
    @objc private func nickNameFieldDidChange(_ textField: UITextField) {
        viewModel.nickName.value = textField.text ?? ""
    }
    @objc private func emailFieldDidChange(_ textField: UITextField) {
        viewModel.email.value = textField.text ?? ""
    }
    @objc private func passwordFieldDidChange(_ textField: UITextField) {
        viewModel.password.value = textField.text ?? ""
    }
    @objc private func passwordCheckFieldDidChange(_ textField: UITextField) {
        viewModel.passwordCheck.value = textField.text ?? ""
    }

}
