//
//  EmailViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/22.
//

import UIKit
import Toast
import RxCocoa
import RxSwift

class EmailViewController: UIViewController {
    
    static let identifier = "EmailViewController"

    let viewModel = PhoneAuthViewModel()
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
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
        guideLabel.text = "이메일을 입력해 주세요"
        
        subLabel.font = CustomFont.Title2_R16.font
        subLabel.textColor = CustomColor.SLPGray7.color
        subLabel.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        
        textField.placeholder = "SeSAC@email.com"
        textField.keyboardType = .emailAddress
        
        doneButton.setTitleWithFont(text: "다음", font: .Body3_R14)
    }
    
    private func bind() {
        let input = PhoneAuthViewModel.Input(text: textField.rx.text, tap: doneButton.rx.tap)
        let output = viewModel.transform(input: input, valid: .email)
        
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
        guard let email = textField.text else { return }
        if doneButton.state == .fakeDisabled {
            if textField.text == "" {
                self.view.makeToast("이메일을 입력해주세요.")
            } else {
                self.view.makeToast("이메일 형식이 올바르지 않습니다.")
            }
        } else {
            UserDefaultManager.signInData.email = email
            let vc = self.storyboard?.instantiateViewController(withIdentifier: GenderViewController.identifier) as! GenderViewController
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }


}
