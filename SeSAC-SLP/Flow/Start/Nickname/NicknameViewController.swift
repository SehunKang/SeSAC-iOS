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
    
    let viewModel = PhoneAuthViewModel()
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var textField: MyTextField!
    @IBOutlet weak var doneButton: FilledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        bind()
        hideKeyboardOnTap()
    }
    
    private func uiConfig() {
        guideLabel.font = CustomFont.Display1_R20.font
        guideLabel.text = "닉네임을 입력해 주세요"
        
        textField.placeholder = "10자 이내로 입력"
        
        textField.keyboardType = .default
        textField.becomeFirstResponder()
        
        doneButton.setTitleWithFont(text: "다음", font: .Body3_R14)
    }
    
    private func bind() {
        let input = PhoneAuthViewModel.Input(text: textField.rx.text, tap: doneButton.rx.tap)
        let output = viewModel.transform(input: input, valid: .nickname)
        
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
    
    private func buttonClicked() {
        if doneButton.state == UIControl.State.fakeDisabled {
            self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.", duration: 1, position: .center, style: ToastManager.shared.style)
        } else {
            UserDefaultManager.signInData.nick = textField.text!
            let vc = self.storyboard?.instantiateViewController(withIdentifier: BirthViewController.identifier) as! BirthViewController
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }


}
