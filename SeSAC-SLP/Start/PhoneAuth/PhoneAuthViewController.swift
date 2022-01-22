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
import Toast

class PhoneAuthViewController: UIViewController {
    
    @IBOutlet weak var phoneNumField: MyTextField!
    @IBOutlet weak var requestCodeButton: FilledButton!
    @IBOutlet weak var guideLabel: UILabel!
    
    let viewModel = PhoneAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfig()
        bind()
        hideKeyboardOnTap()
        
    }
    
    private func uiConfig() {
        
        let image = UIImage(named: "arrow")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        guideLabel.numberOfLines = 0
        guideLabel.textAlignment = .center
        guideLabel.font = CustomFont.Display1_R20.font
        guideLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        
        phoneNumField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        phoneNumField.keyboardType = .numberPad
        
        requestCodeButton.setTitleWithFont(text: "인증 문자 받기", font: .Body3_R14)
    }
    
    private func bind() {
        
        let input = PhoneAuthViewModel.Input(text: phoneNumField.rx.text, tap: requestCodeButton.rx.tap)
        let output = viewModel.transform(input: input, valid: .phoneNum)
        
        output.newText
            .bind(to: phoneNumField.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        output.validStatus
            .bind(to: requestCodeButton.rx.isFakeDisbaled)
            .disposed(by: viewModel.disposeBag)
        
        output.sceneTransition
            .subscribe { _ in
                if self.requestCodeButton.state == UIControl.State.fakeDisabled {
                    self.view.makeToast("잘못된 전화번호 형식입니다.")
                } else {
                    self.viewModel.requestVerifyId(phoneNumber: self.phoneNumField.text) { error in
                        if error != nil {
                            self.view.makeToast("오류 발생!\n잠시후에 다시 시도해주세요")
                            print("error:", error as Any)
                            return
                        } else {
                            self.requestCodeButton.isUserInteractionEnabled = false
                            
                            self.view.makeToast("전화번호 인증 시작", duration: 2, position: .center, title: nil, image: nil, style: ToastManager.shared.style) { didTap in
                                self.requestCodeButton.isUserInteractionEnabled = true
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneAuthCheckViewController") as! PhoneAuthCheckViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                                vc.view.makeToast("인증번호를 보냈습니다", duration: 1, position: .center, style: ToastManager.shared.style)
                            }
                        }
                    }
                }
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
    
}
