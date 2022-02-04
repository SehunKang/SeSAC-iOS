//
//  MyInfoDetailViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/02.
//

import UIKit
import RangeSeekSlider

class MyInfoDetailViewController: UIViewController {
    
    static let identifier = "MyInfoDetailViewController"
    
    let viewModel = MyInfoDetailViewModel()
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var sesacFaceImage: UIImageView!
    @IBOutlet var textMyGender: UILabel!
    @IBOutlet var buttonMale: InactiveButton!
    @IBOutlet var buttonFemale: InactiveButton!
    @IBOutlet var textMyHobby: UILabel!
    @IBOutlet var textFieldMyHobby: MyTextField!
    @IBOutlet var textPhonenumSearchable: UILabel!
    @IBOutlet var switchPhonenumSearchable: UISwitch!
    @IBOutlet var textAgeRange: UILabel!
    @IBOutlet var resultAgeRange: UILabel!
    @IBOutlet var rangeSeeker: RangeSeekSlider!
    @IBOutlet var buttonWithdraw: UIButton!
    @IBOutlet var cardView: UILabel!
    
    private var genderValue: Gender = .none {
        didSet {
            switch genderValue {
            case .male:
                buttonMale.isSelected = true
                buttonFemale.isSelected = false
            case .female:
                buttonMale.isSelected = false
                buttonFemale.isSelected = true
            case .none:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        title = "정보 관리"
        basicUIConfigure()
        uiConfigureWithData()
        hideKeyboardOnTap()
        
    }
    
    private func basicUIConfigure() {
        
        backgroundImage.layer.cornerRadius = 8
        
        textMyGender.text = "내 성별"
        textMyGender.font = CustomFont.Title4_R14.font
        
        buttonMale.setTitleWithFont(text: "남자", font: .Body3_R14)
        buttonFemale.setTitleWithFont(text: "여자", font: .Body3_R14)
        
        textMyHobby.text = "자주 하는 취미"
        textMyHobby.font = CustomFont.Title4_R14.font
        
        textFieldMyHobby.placeholder = "취미를 입력해 주세요"
        
        textPhonenumSearchable.text = "내 번호 검색 허용"
        textPhonenumSearchable.font = CustomFont.Title4_R14.font
        
        switchPhonenumSearchable.onTintColor = CustomColor.SLPGreen.color
        
        textAgeRange.text = "상대방 연령대"
        textAgeRange.font = CustomFont.Title4_R14.font
        
        resultAgeRange.font = CustomFont.Title3_M14.font
        resultAgeRange.textColor = CustomColor.SLPGreen.color
        
        buttonWithdraw.setAttributedTitle(NSAttributedString(string: "회원탈퇴", attributes: [.font: CustomFont.Title4_R14.font, .foregroundColor: CustomColor.SLPBlack.color]), for: .normal)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicekd))
    }
    
    private func uiConfigureWithData() {
    
        backgroundImage.image = UIImage(named: "sesac_background_1")
        sesacFaceImage.image = UIImage(named: "sesac_face_1")
        
        cardView.text = UserDefaultManager.userData?.nick
        
        
        switch viewModel.userData?.gender {
        case Gender.male.rawValue:
            buttonMale.isSelected = true
        case Gender.female.rawValue:
            buttonFemale.isSelected = true
        default:
            break
        }
        
        textFieldMyHobby.text = viewModel.userData?.hobby
        
        if viewModel.userData?.searchable == 0 {
            switchPhonenumSearchable.isOn = false
        }
        
        rangeSeeker.delegate = self
        rangeSeeker.selectedMinValue = CGFloat(viewModel.userData?.ageMin ?? Int(18.0))
        rangeSeeker.selectedMaxValue = CGFloat(viewModel.userData?.ageMax ?? Int(35.0))
        
        resultAgeRange.text = "\(Int(rangeSeeker.selectedMinValue)) - \(Int(rangeSeeker.selectedMaxValue))"
        
        buttonMale.rx.tap
            .subscribe { _ in
                self.genderValue = Gender.male
            }
            .disposed(by: viewModel.disposeBag)
        
        buttonFemale.rx.tap
            .subscribe { _ in
                self.genderValue = Gender.female
            }
            .disposed(by: viewModel.disposeBag)

        buttonWithdraw.rx.tap
            .subscribe { _ in
                self.withdraw()
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    private func withdraw() {
        viewModel.withdraw { code in
            switch code {
            case 200, 406:
                print("goto onboarding")
            default:
                self.errorHandler(with: code)
            }
        }
    }
    
    @objc func saveButtonClicekd() {
        let searchable = switchPhonenumSearchable.isOn ? 1 : 0
        let ageMin = Int(rangeSeeker.selectedMinValue)
        let ageMax = Int(rangeSeeker.selectedMaxValue)
        let gender = genderValue.rawValue
        let hobby = textFieldMyHobby.text ?? ""
        
        let dataForUpdate = DataForUpdate(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, hobby: hobby)
        
        viewModel.updateMyPage(data: dataForUpdate) { code in
            print("updatemypagecode??", code)
            switch code {
            case 200:
                self.navigationController?.popViewController(animated: true)
            default:
                self.errorHandler(with: code)
            }
        }
        
        
    }

    
}

extension MyInfoDetailViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        resultAgeRange.text = "\(Int(minValue)) - \(Int(maxValue))"
    }
}
