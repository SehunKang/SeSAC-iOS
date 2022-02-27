//
//  BirthViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/22.
//

import UIKit
import Toast
import RxCocoa
import RxSwift

class BirthViewController: UIViewController {
    
    static let identifier = "BirthViewController"
    
    let viewModel = PhoneAuthViewModel()

    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var yearField: MyTextField!
    @IBOutlet weak var monthField: MyTextField!
    @IBOutlet weak var dateField: MyTextField!
    @IBOutlet weak var doneButton: FilledButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        bind()
        hideKeyboardOnTap()
        datePicker.becomeFirstResponder()
    }
    
    private func uiConfig() {
        guideLabel.text = "생년월일을 알려주세요"
        guideLabel.font = CustomFont.Display1_R20.font
        
        yearField.placeholder = "1990"
        monthField.placeholder = "1"
        dateField.placeholder = "1"
        [yearField, monthField, dateField].forEach {
            $0?.delegate = self
        }
        
        doneButton.setTitleWithFont(text: "다음", font: .Body3_R14)
        doneButton.isFakeDisbaled = true
        
        let minAge = Calendar.current.date(byAdding: .year, value: -17, to: Date())
        let maxAge = Calendar.current.date(byAdding: .year, value: -65, to: Date())
        datePicker.maximumDate = minAge
        datePicker.minimumDate = maxAge
        
        self.navigationItem.backButtonTitle = ""

    }
    
    private func bind() {
        
        doneButton.rx.tap
            .subscribe { _ in
                self.doneButtonClicked()
            }
            .disposed(by: viewModel.disposeBag)
    }

    @IBAction func datePicked(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: sender.date)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: sender.date)
        formatter.dateFormat = "dd"
        let date = formatter.string(from: sender.date)
        
        yearField.text = year
        monthField.text = month
        dateField.text = date
        
        let val: Bool = viewModel.checkDateValue("\(year)\(month)\(date)")
        doneButton.isFakeDisbaled = val
    }
    
    private func doneButtonClicked() {
        if doneButton.state == .fakeDisabled {
            if yearField.text == "" {
                self.view.makeToast("생년월일을 입력해 주세요")
            } else {
                self.view.makeToast("새싹친구는 만 17세 이상만 사용할 수 있습니다.")
            }
        } else {
            UserDefaultManager.signInData.birth = datePicker.date
            let vc = self.storyboard?.instantiateViewController(withIdentifier: EmailViewController.identifier) as! EmailViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print(datePicker.date)
    }
    
}

extension BirthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        datePicker.isHidden = true
    }
}
