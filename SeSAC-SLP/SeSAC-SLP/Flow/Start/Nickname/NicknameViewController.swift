//
//  NicknameViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/22.
//

import UIKit
import Toast
import RxCocoa
import RxSwift

class NicknameViewController: UIViewController {
    
    static let identifier = "NicknameViewController"
    
    let viewModel = NickNameViewModel()
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var textField: MyTextField!
    @IBOutlet weak var doneButton: FilledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        bind()
        hideKeyboardOnTap()
        validNickAlert()
        print(UserDefaultManager.idtoken)
    }
    
    private func uiConfig() {
        guideLabel.font = CustomFont.Display1_R20.font
        guideLabel.text = "닉네임을 입력해 주세요"
        
        textField.placeholder = "10자 이내로 입력"
        
        textField.keyboardType = .default
        textField.becomeFirstResponder()
        
        doneButton.setTitleWithFont(text: "다음", font: .Body3_R14)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backButtonTitle = ""
    }
    
    private func bind() {
        let input = NickNameViewModel.Input(text: textField.rx.text, tap: doneButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.newText
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
        
    }
    
    private func validNickAlert() {
        if UserDefaultManager.validNickFlag == 1 {
            easyAlert(vc: self, title: "닉네임 오류" , message: "\(UserDefaultManager.signInData.nick)은/는 사용하실 수 없는 닉네임입니다.")
        }
    }
    
    private func buttonClicked() {
        if doneButton.state == UIControl.State.fakeDisabled {
            self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.", duration: 1, position: .center, style: ToastManager.shared.style)
        } else {
            UserDefaultManager.signInData.nick = textField.text!
            if UserDefaultManager.validNickFlag == 1 {
                APIServiceForStart.signIn { statusCode in
                    switch statusCode {
                    case 200:
                        UserDefaultManager.validNickFlag = 0
                        self.goHome()
                    case 201:
                        print("이미가입한 유저??")
                    case 202:
                        self.validNickAlert()
                    case 401:
                        print("refresh token")
                    default:
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    }
                }
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: BirthViewController.identifier) as! BirthViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }


}
