//
//  ViewController.swift
//  SeSAC_Week14
//
//  Created by Sehun Kang on 2021/12/27.
//

import UIKit

class SignInViewController: UIViewController {

    let mainView = SignInView()
    
    var viewModel = SignInViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.username.bind { text in
            print(text)
            self.mainView.usernameTextField.text = text
        }
        
        viewModel.password.bind { text in
            self.mainView.passwordTextField.text = text
        }
        
        mainView.usernameTextField.addTarget(self, action: #selector(usernameTextFieldDidChange(_:)), for: .editingChanged)
        mainView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)

        
        mainView.signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        mainView.signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
    @objc func usernameTextFieldDidChange(_ textField: UITextField) {
        viewModel.username.value = textField.text ?? ""
    }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        viewModel.password.value = textField.text ?? ""
    }

    @objc func signInButtonClicked() {
        print("Click")
        viewModel.postUserLogin {
            //로그인 성공시 시작화면 변경
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
    }
    
    @objc func signUpButtonClicked() {
        
        //직접 푸쉬해도 되나?
        //푸쉬했을때 기존 뷰가 사라지는게 스무스하지 못하다.
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        
    }

}

