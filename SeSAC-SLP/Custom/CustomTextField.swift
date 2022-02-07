//
//  MyTextField.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/19.
//

import UIKit

class MyTextField: UITextField, UITextFieldDelegate {
    
    private let border = CALayer()
    
    private var lineColor: UIColor = CustomColor.SLPGray3.color {
        didSet {
            border.borderColor = lineColor.cgColor
        }
    }
    
    
    open var lineHeight: CGFloat = CGFloat(1.0) {
        didSet {
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        textFieldSet()
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.alertLabel = UILabel()
        
        textFieldSet()
        alertLabelSet()
        bringSubviewToFront(alertLabel)
        autocorrectionType = .no

    }
    

    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: -12, y: self.frame.size.height - lineHeight, width: self.frame.size.width + 24, height: lineHeight)
    }
    
    // copy/paste 방지
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    private func textFieldSet() {
        self.borderStyle = .none
        self.layer.cornerRadius = 8
        self.delegate = self
        self.font = CustomFont.Title4_R14.font
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPGray3.color, NSAttributedString.Key.font: CustomFont.Title4_R14.font])
        
        border.borderColor = lineColor.cgColor
        border.frame = CGRect(x: -12, y: self.frame.size.height - lineHeight, width: self.frame.size.width + 24, height: lineHeight)
        border.borderWidth = lineHeight
        self.layer.addSublayer(border)
    }
    
    private var alertLabel = UILabel()
    
    private func alertLabelSet() {
        alertLabel.font = CustomFont.Body4_R12.font
        alertLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 14)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.clipsToBounds = true
//        super.addSubview(alertLabel)
        self.addSubview(self.alertLabel)
        alertLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        alertLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        alertLabel.isHidden = true
    }
    
    /// errorMessage를 설정해야함 false 되지 않는이상 상태가 지속됨
    var isError: Bool = false {
        didSet {
            if self.isEnabled == true {
                if isError == true {
                    print(alertLabel.isHidden)
                    alertLabel.text = errorMessage
                    alertLabel.textColor = CustomColor.SLPError.color
                    border.borderColor = CustomColor.SLPError.color.cgColor
                    alertLabel.isHidden = false
                } else {
                    alertLabel.isHidden = true
                }
            }
        }
    }
    
    /// successMessage를 설정해야함 false 되지 않는이상 상태가 지속
    var isSuccess: Bool = false {
        didSet {
            if self.isEnabled == true {
                if isSuccess == true {
                    alertLabel.text = successMessage
                    alertLabel.textColor = CustomColor.SLPSuccess.color
                    border.borderColor = CustomColor.SLPSuccess.color.cgColor
                    alertLabel.isHidden = false
                } else {
                    alertLabel.isHidden = true
                }
            }
        }
    }
    
    var errorMessage: String = ""
    var successMessage: String = ""
    
    /// isError플래그 true 후 3초뒤에 false시킨다.
    func showError() {
        isError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isError = false
            self.border.borderColor = self.lineColor.cgColor
        }
    }
    /// isSuccess플래그 true 후 3초뒤에 false시킨다.
    func showSuccess() {
        isSuccess = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isSuccess = false
            self.border.borderColor = self.lineColor.cgColor
        }
    }
    
    override var isEnabled: Bool {
        willSet {
            if newValue == false {
                self.clipsToBounds = true
                self.border.borderColor = CustomColor.SLPGray3.color.cgColor
                self.backgroundColor = CustomColor.SLPGray3.color
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPGray7.color])
            } else {
                self.clipsToBounds = false
                self.border.borderColor = lineColor.cgColor
                self.backgroundColor = .clear
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPGray3.color])
            }
        }
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
//        self.delegate = self
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lineColor = CustomColor.SLPBlack.color
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        lineColor = CustomColor.SLPGray3.color
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }


}
