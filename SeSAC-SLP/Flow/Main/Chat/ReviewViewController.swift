//
//  ReviewViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ReviewViewController: UIViewController {
    
    static let identifier = "ReportViewController"
    
    let bag = DisposeBag()
    
    let placeholderSting = "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n(500자 이내 작성)"
    
    var result = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var uid: String = ""
    var userName: String = ""
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Title3_M14.font
        label.textColor = CustomColor.SLPBlack.color
        label.text = "리뷰 등록"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Body3_R14.font
        label.textColor = CustomColor.SLPGreen.color
        label.text = "\(userName)님과의 취미 활동은 어떠셨나요?"
        return label
    }()
    
    private let fraud: UIButton = {
        let button = UIButton()
        button.setTitle("좋은 매너", for: .normal)
        button.reportConfigure()
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    private let argue: UIButton = {
        let button = UIButton()
        button.setTitle("빠른 응답", for: .normal)
        button.reportConfigure()
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    private let noshow: UIButton = {
        let button = UIButton()
        button.setTitle("능숙한 취미 실력", for: .normal)
        button.reportConfigure()
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.tag = 4
        return button
    }()
    
    private let explicit: UIButton = {
        let button = UIButton()
        button.setTitle("정확한 시간 약속", for: .normal)
        button.reportConfigure()
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    private let humiliate: UIButton = {
        let button = UIButton()
        button.setTitle("친절한 성격", for: .normal)
        button.reportConfigure()
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.tag = 3
        return button
    }()
    private let etc: UIButton = {
        let button = UIButton()
        button.setTitle("유익한 시간", for: .normal)
        button.reportConfigure()
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.tag = 5
        return button
    }()
    private lazy var firstRowStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [fraud, argue, noshow])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    private lazy var secondRowStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [explicit, humiliate, etc])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = CustomFont.Body3_R14.font
        view.textColor = CustomColor.SLPGray7.color
        view.text = placeholderSting
        view.backgroundColor = CustomColor.SLPGray1.color
        view.heightAnchor.constraint(equalToConstant: 124).isActive = true
        return view
    }()
    
    private let escapeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage(named: "close_big"), for: .normal)
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("신고하기", for: .normal)
        button.titleLabel?.font = CustomFont.Body3_R14.font
        button.titleLabel?.textColor = CustomColor.SLPGray3.color
        button.backgroundColor = CustomColor.SLPGray6.color
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.cornerRadius = 8
        return button
    }()
        
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [subTitleLabel, buttonStackView, textView, doneButton])
        view.axis = .vertical
        view.spacing = 24
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    convenience init(uid: String = "", userName: String = "") {
        self.init()
        
        self.uid = uid
        self.userName = userName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.5)
        textView.delegate = self
        setupView()
        bind()
        hideKeyboardOnTap()
        keyboardConfigure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }

    private func setupView() {
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(escapeButton)
        containerView.addSubview(containerStackView)
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.trailing.equalTo(view).inset(16)
            make.top.greaterThanOrEqualTo(view.snp.top).offset(24)
            make.bottom.lessThanOrEqualTo(view.snp.bottom).inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        escapeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.top)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(containerView).inset(16)
        }
    }
    @objc private func buttonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.reportButtonSelected()
            result[sender.tag] = 1
        } else {
            sender.reportConfigure()
            result[sender.tag] = 0
        }
    }

    private func bind() {
        escapeButton.rx.tap
            .subscribe {[weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: bag)
        
        doneButton.rx.tap
            .subscribe {[weak self] _ in
                print(self?.result as Any)
            }
            .disposed(by: bag)
        
        textView.rx.text
            .orEmpty
            .map { text in
                text.count > 0 && text != self.placeholderSting
            }
            .subscribe {[weak self] value in
                guard let result = value.element else { return }
                if result {
                    self?.doneButton.isEnabled = true
                    self?.doneButton.titleLabel?.textColor = CustomColor.SLPWhite.color
                    self?.doneButton.backgroundColor = CustomColor.SLPGreen.color
                } else {
                    self?.doneButton.isEnabled = false
                    self?.doneButton.titleLabel?.textColor = CustomColor.SLPGray3.color
                    self?.doneButton.backgroundColor = CustomColor.SLPGray6.color
                }
            }
            .disposed(by: bag)
        
        doneButton.rx.tap
            .subscribe { [weak self] _ in
                self?.doneButtonClicked()
            }
            .disposed(by: bag)
    }
    
    
    private func doneButtonClicked() {
        let data: [String: Any] = ["otheruid": uid, "reputation": result, "comment": textView.text!]
        APIServiceForChat.report(data: data) {[weak self] result in
            switch result {
            case 200:
                UserDefaultManager.userStatus = UserStatus.normal.rawValue
                self?.goHome()
            case 401:
                self?.refreshToken {
                    self?.doneButtonClicked()
                }
            default:
                self?.errorHandler(with: result)
            }
        }
    }

    private func keyboardConfigure() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let result = self.view.frame.height - keyboardSize.height - containerView.frame.maxY
            
            self.containerView.transform = CGAffineTransform(translationX: 0, y: result)
        }
    }
    @objc private func keyboardDown(_ notification: NSNotification) {
        self.containerView.transform = .identity
    }

}

extension ReviewViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = CustomColor.SLPBlack.color
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
    }
}
