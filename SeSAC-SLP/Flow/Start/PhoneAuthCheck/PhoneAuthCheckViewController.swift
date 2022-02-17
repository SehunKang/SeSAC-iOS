//
//  PhoneAuthCheckViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/19.
//

import UIKit
import Toast
import RxCocoa
import RxSwift

class PhoneAuthCheckViewController: UIViewController {
    
    let viewModel = PhoneAuthViewModel()

    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var textField: MyTextField!
    @IBOutlet weak var doneButton: FilledButton!
    @IBOutlet weak var resendButton: FilledButton!
    @IBOutlet weak var countDownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        bind()
        hideKeyboardOnTap()
        internetCheck()
    }
    
    private func uiConfig() {
        
        guideLabel.font = CustomFont.Display1_R20.font
        guideLabel.text = "인증번호가 문자로 전송되었어요"
        
        subLabel.font = CustomFont.Title2_R16.font
        subLabel.textColor = CustomColor.SLPGray7.color
        subLabel.text = "(최대 소모 20초)"
        
        countDownLabel.font = CustomFont.Title3_M14.font
        countDownLabel.textColor = CustomColor.SLPGreen.color
        setTimer(time: 60)
        
        textField.placeholder = "인증번호 입력"
        textField.keyboardType = .numberPad
        
        resendButton.setTitleWithFont(text: "재전송", font: .Body3_R14)
        resendButton.isEnabled = false
        
        doneButton.setTitleWithFont(text: "인증하고 시작하기", font: .Body3_R14)
    }
    
    private func bind() {
        let input = PhoneAuthViewModel.Input(text: textField.rx.text, tap: doneButton.rx.tap)
        let output = viewModel.transform(input: input, valid: .code)
        
        output.newText
            .map { text in
                self.viewModel.validationNumberFormat(with: validationFieldText.code.rawValue, text: text)
            }
            .bind(to: textField.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        output.validStatus
            .bind(to: doneButton.rx.isFakeDisbaled)
            .disposed(by: viewModel.disposeBag)
        
        output.sceneTransition
            .subscribe { _ in
                self.buttonClicked()
            }
            .disposed(by: viewModel.disposeBag)
        
        resendButton.rx.tap
            .subscribe { _ in
                self.resendCode()
            }
            .disposed(by: viewModel.disposeBag)

        
    }

    
    private func setTimer(time: Int) {
        Observable<Int>
            .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(time + 1)
            .subscribe { timePassed in
                let count = time - timePassed
                let text: String
                if count == 60 {
                    text = "01:00"
                } else if count >= 10{
                    text = "00:\(count)"
                } else {
                    text = "00:0\(count)"
                }
                self.countDownLabel.text = text
            } onCompleted: {
                self.view.makeToast("전화번호 인증 실패", duration: 1.5, position: .center, style: ToastManager.shared.style) { didTap in
                    self.resendButton.isEnabled = true
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    private func resendCode() {
        
        viewModel.resendRequest() { error in
            if error != nil {
                print("what error?", error?.localizedDescription as Any)
                self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요")
            } else {
                self.setTimer(time: 60)
                self.resendButton.isEnabled = false
            }
        }
    }
    
    private func buttonClicked() {
        if doneButton.state == UIControl.State.fakeDisabled {
            self.view.makeToast("잘못된 인증번호입니다.", duration: 1, position: .center, style: ToastManager.shared.style)
        } else {
            viewModel.credentialCheck(verifyCode: textField.text) { error, result in
                if error != nil {
                    self.view.makeToast("전화번호 인증 실패")
                    print(error.debugDescription)
                } else {
                    APIServiceForStart.getUserData { code in
                        switch code {
                        case 200:
                            self.goHome()
                        case 401:
                            self.refreshToken {
                                self.buttonClicked()
                            }
                        case 406:
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: NicknameViewController.identifier) as! NicknameViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        default:
                            self.errorHandler(with: code)
                        }
                    }
                }
            }
        }
    }
}
