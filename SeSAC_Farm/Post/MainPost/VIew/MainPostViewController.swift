//
//  MainPostViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit
import SnapKit

class MainPostViewController: UIViewController {
    
    let viewModel = MainPostViewModel()
    
    let tableView = UITableView()
    let plusButton = PlustButtonVIew()
    
    override func loadView() {
        viewModel.getPost { error in
            if error != nil {
                print("error in MainPostViewController")
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewInit()
        plusButtonConfig()
    }
    
    private func tableViewInit() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(FirstRowCell.self, forCellReuseIdentifier: FirstRowCell.identifier)
        tableView.register(SecondRowCell.self, forCellReuseIdentifier: SecondRowCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func plusButtonConfig() {
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
    }
}

extension MainPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 44
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.cellForRowAt(at: indexPath)
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstRowCell.identifier) as? FirstRowCell else {return UITableViewCell()}
            cell.nameLabel.text = data.user.username
            cell.postLabel.text = data.text
            cell.dateLabel.text = data.updatedAt
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SecondRowCell.identifier) as? SecondRowCell else {return UITableViewCell()}
            cell.commentLabel.text = data.comments.count > 0 ? "댓글 \(data.comments.count)" : "댓글쓰기"
            return cell
        }
    }
    
    
    
}
