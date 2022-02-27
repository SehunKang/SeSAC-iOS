//
//  InitialViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit

class InitialViewController: UIViewController {
    
    let mainView = InitialView()
    
    let viewModel = InitialViewViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.startButton.startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        mainView.signUpCheckView.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func start() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func signIn() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
}


