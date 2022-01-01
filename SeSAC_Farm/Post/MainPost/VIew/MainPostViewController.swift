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
    //프레임을 설정해줘야 원이 된다... why?
    let plusButton = PlustButtonVIew(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "새싹농장"
        view.backgroundColor = .systemBackground
        
        viewModel.getPost { error in
            if let error = error {
                print(error)
                //사용자에게 안내 후
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: InitialViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            }
        }
        
        viewModel.post.bind { post in
            self.tableView.reloadData()
        }
        
        tableViewInit()
        plusButtonConfig()
    }
    
    private func tableViewInit() {
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        
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
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        plusButton.layer.shadowRadius = 5
        plusButton.layer.shadowOpacity = 0.3

        view.addSubview(plusButton)

        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.width.equalTo(80)
            make.height.equalTo(80)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModel.numberOfSection - 1 { return 0 }
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.cellForRowAt(at: indexPath)
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstRowCell.identifier) as? FirstRowCell else {return UITableViewCell()}
            cell.nameLabel.text = data.user.username
            cell.postLabel.text = data.text
            cell.dateLabel.text = data.updatedAt.dateFormat()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SecondRowCell.identifier) as? SecondRowCell else {return UITableViewCell()}
            cell.commentLabel.text = data.comments.count > 0 ? "댓글 \(data.comments.count)" : "댓글쓰기"
            cell.separatorInset = .zero
            return cell
        }
    }
    
    
    
}
