//
//  MainViewController.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/20.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

class MainViewController: UIViewController {
    
    let tableView = UITableView()
    
    var beerData: BeerElement?
    
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        dataHandle()
        refresh()

        setTableView()
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(88)
            make.bottom.equalTo(view.snp.bottom)
        }
        let customView = CustomView()
        customView.refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        let customItem = UIBarButtonItem(customView: customView)
        toolBar.setItems([customItem], animated: true)
        
    }
    
    @objc func refresh() {
        apiService.requestCast { beer in
            self.beerData = beer
            print("main? = ", Thread.isMainThread)
            //메인스레드에서 리로드해줘야함
            DispatchQueue.main.async {
                print(Thread.isMainThread)
                self.tableView.reloadData()
                self.setHeaderView()
            }
        }
    }
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2))
        self.tableView.tableHeaderView = header
        setHeaderView()
    
    }
    
    func setHeaderView() {
        let header = self.tableView.tableHeaderView as! StretchyTableHeaderView
        header.imageView.image = UIImage()
        header.imageView.backgroundColor = .yellow
        header.discriptionView.nameLabel.text = beerData?.name
        header.discriptionView.companyLabel.text = beerData?.tagline
        header.discriptionView.discriptionLabel.text = beerData?.beerDescription

    }
    
    func dataHandle() {
        guard let data = jsonData.data(using: .utf8) else { fatalError() }
        do {
            self.beerData = try JSONDecoder().decode(BeerElement.self, from: data)
//            dump(beerData)
        } catch {
            print(error)
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 500
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.bounds.height / 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MainTableViewCell()
        let text = beerData?.foodPairing.joined(separator: "\n")
        cell.secondView.paringLabel.attributedText = text?.lineSpaced(10)
        cell.secondView.explanationLabel.text = beerData?.brewersTips
        return cell
    }
    
    
    
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let headerView = self.tableView.tableHeaderView as! StretchyTableHeaderView
        
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

extension String {

    func lineSpaced(_ spacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return attributedString
    }
}
