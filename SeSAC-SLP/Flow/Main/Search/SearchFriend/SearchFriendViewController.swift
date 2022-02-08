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
        
        title = "새싹 찾기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopFind))
        
        self.dataSource = self
        
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
        navBarBackButtonConfigure()
    }
    
    @objc func stopFind() {
        
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
