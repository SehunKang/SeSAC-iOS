//
//  ShopViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import UIKit
import Tabman
import Pageboy
import SnapKit

class ShopViewController: TabmanViewController {
    
    static let identifier = "ShopViewController"
    let backgroundImageView = UIImageView()
    let foregroundImageView = UIImageView()
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = CustomColor.SLPGreen.color
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = CustomFont.Body3_R14.font
        button.setTitleColor(CustomColor.SLPWhite.color, for: .normal)
        return button
    }()
    
    private var viewControllers = [ForegroundShopViewController(), BackgroundShopViewController()]
    
    var foregroundImage = -1 {
        didSet {
            foregroundImageView.image = UIImage(named: "sesac_face_\(foregroundImage)")
        }
    }
    var backgroundImage = -1 {
        didSet {
            backgroundImageView.image = UIImage(named: "sesac_background_\(backgroundImage)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "새싹샵"
        getMyInfo()
        imageViewConfigure()
        tabmanConfigure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(foregroundClicked(_:)), name: NSNotification.Name("foregroundClicked"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundClicked(_:)), name: NSNotification.Name("backgroundClicked"), object: nil)
        
    }
    
    private func getMyInfo() {
        APIServiceForShop.myInfo {[weak self] myInfo, result in
            guard let self = self else {return}
            if let myInfo = myInfo {
                self.foregroundImage = myInfo.sesac
                self.backgroundImage = myInfo.background
            }
            if let result = result {
                switch result {
                case 401:
                    self.refreshToken {
                        self.getMyInfo()
                    }
                default:
                    self.errorHandler(with: result)
                }
            }
        }
    }
    
    private func imageViewConfigure() {
        backgroundImageView.layer.cornerRadius = 8
        view.addSubview(backgroundImageView)
        view.addSubview(foregroundImageView)
        view.addSubview(saveButton)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(194)
        }
        foregroundImageView.snp.makeConstraints { make in
            make.height.width.equalTo(184)
            make.center.equalTo(backgroundImageView)
        }
        saveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(backgroundImageView).inset(8)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    @objc private func saveButtonClicked() {
        APIServiceForShop.update(sesacImage: foregroundImage, backgroundImage: backgroundImage) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case 200:
                self.view.makeToast("성공적으로 저장되었습니다.")
            case 201:
                self.view.makeToast("구매가 필요한 아이템이 있어요")
            case 401:
                self.refreshToken {
                    self.saveButtonClicked()
                }
            default:
                self.errorHandler(with: result)
            }
        }
    }
    
    private func tabmanConfigure() {
        self.dataSource = self
        self.automaticallyAdjustsChildInsets = true

        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.layout.alignment = .centerDistributed
        bar.layout.interButtonSpacing = 0
        bar.indicator.tintColor = CustomColor.SLPGreen.color
        bar.indicator.weight = .light
        bar.layer.borderColor = CustomColor.SLPGray2.color.cgColor
        bar.layer.borderWidth = 1
        
        bar.buttons.customize { button in
            button.tintColor = CustomColor.SLPGray6.color
            button.selectedTintColor = CustomColor.SLPGreen.color
            button.font = CustomFont.Title4_R14.font
            button.selectedFont = CustomFont.Title3_M14.font
            button.backgroundColor = .systemBackground
        }
        
        addBar(bar, dataSource: self, at: .custom(view: self.view, layout: { bar in
            bar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bar.topAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor),
                bar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                bar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }))

    }
    
    @objc func foregroundClicked(_ notification: Notification) {
        guard let item = notification.userInfo?["item"] as? Int else {return}
        foregroundImage = item
    }
    
    @objc func backgroundClicked(_ notification: Notification) {
        guard let item = notification.userInfo?["item"] as? Int else {return}
        backgroundImage = item
    }


}

extension ShopViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title: String = index == 0 ? "새싹" : "배경"
        return TMBarItem(title: title)
    }

}
