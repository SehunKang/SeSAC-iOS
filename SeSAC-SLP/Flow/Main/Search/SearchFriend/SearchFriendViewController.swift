//
//  SearchFriendViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/07.
//

import UIKit
import Tabman
import Pageboy

class SearchFriendViewController: TabmanViewController {

    static let identifier = "SearchFriendViewController"
    
    private var viewControllers = [AroundViewController(), RequestReceivedViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfig()
//        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: CustomFont.Title3_M14.font], for: .normal)
        
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
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func navBarConfig() {
        title = "새싹 찾기"
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonInNavigationBarClicked) )
        self.navigationItem.leftBarButtonItem = backButton
        
        let rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopFind))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    @objc func backButtonInNavigationBarClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    @objc func stopFind() {
        APIServiceForSearch.delete { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    UserDefaultManager.userStatus = UserStatus.normal.rawValue
                    self.navigationController?.popToRootViewController(animated: true)
                case 201:
                    self.view.makeToast("누군가와 취미를 함께하기로 약송하셨어요!")
                    print("goto chat")
                default:
                    return
                }
            case .failure(let error):
                self.errorHandler(with: error.errorCode)
            }
        }
    }

}
extension SearchFriendViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
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
        let title: String = index == 0 ? "주변 새싹" : "받은 요청"
        return TMBarItem(title: title)
    }
    
    
}
