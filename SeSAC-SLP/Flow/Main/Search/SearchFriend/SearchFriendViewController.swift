//
//  SearchFriendViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/07.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import Toast

class SearchFriendViewController: TabmanViewController {
    
    var disposeBag = DisposeBag()
    
    static let identifier = "SearchFriendViewController"
    
    private var viewControllers = [AroundViewController(), RequestReceivedViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfig()
        
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
        statusCheck()
    }
    
    private func statusCheck() {
        
        //뷰를 벗어나도 작동되는데, 그 후의 함수 실행에 문제가 있을 것 같다.
        Observable<Int>.timer(.seconds(1), period: .seconds(5), scheduler: MainScheduler.asyncInstance)
            .subscribe { _ in
                self.myQueueStatus()
                if UserDefaultManager.userStatus == UserStatus.normal.rawValue {
                    self.stopStatusCheck()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func myQueueStatus() {
        print("status check")
        APIServiceForSearch.myQueueState { result in
            switch result {
            case .success(let response):
                let responseData = try? response.map(MyQueueStatus.self)
                switch response.statusCode {
                case 200:
                    if responseData?.matched == 1 {
                        UserDefaultManager.userStatus = UserStatus.doneMatching.rawValue
                        self.view.makeToast("\(responseData!.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다", duration: 1, position: .center,  style: ToastManager.shared.style) { _ in
                            print("goto chat")
                        }
                    }
                case 201:
                    self.view.makeToast("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", duration: 1, position: .center, style: ToastManager.shared.style) { _ in
                        UserDefaultManager.userStatus = UserStatus.normal.rawValue
                        self.goHome()
                    }
                default: return
                }
            case .failure(let failure):
                self.errorHandler(with: failure.errorCode)
            }
        }
    }
    
    private func stopStatusCheck() {
        self.disposeBag = DisposeBag()
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
                    self.disposeBag = DisposeBag()
                    self.navigationController?.popToRootViewController(animated: true)
                case 201:
                    self.view.makeToast("누군가와 취미를 함께하기로 약속하셨어요!")
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
