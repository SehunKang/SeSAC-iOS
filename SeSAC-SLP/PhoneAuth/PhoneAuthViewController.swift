//
//  ViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/17.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class PhoneAuthViewController: UIViewController {
    
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var requestCodeButton: UIButton!
    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testLabel2: UILabel!
    
    let viewModel = PhoneAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
//        testLabel.font = UIFont(name: "Noto Sans KR", size: 20)
        testLabel.text = "동해물과백두산이마르고닳도록"
        testLabel2.text = "동해물과백두산이마르고닳도록"
        testLabel2.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        
    }
    
    func bind() {
                
        let input = PhoneAuthViewModel.Input(text: phoneNumField.rx.text)
        let output = viewModel.transform(input: input)
        output.newText
            .bind(to: phoneNumField.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        output.validStatus
            .bind(to: requestCodeButton.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
    
        
    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        viewModel.requestVerifyId(phoneNumber: phoneNumField.text) { error in
            if let error = error {
                print("error in requestVerifyCode", error as Any)
            }
        }
    }
    
    @IBAction func verifyButtonClicked(_ sender: UIButton) {
        
        viewModel.credentialCheck(verifyCode: codeField.text) { error, result in
            if let error = error {
                print("error in credentialCheck", error as Any)
            } else {
                print("success", result as Any)
            }
        }
    }
}
