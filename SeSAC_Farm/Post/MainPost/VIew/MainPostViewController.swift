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
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    //프레임을 직접 설정해줘야 원이 된다... why?
    let plusButton = PlustButtonVIew(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
//    var postData: [Post] = []

      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.post.bind { posts in
            self.tableView.reloadData()
        }
        navBarConfig()
        tableViewConfig()
        plusButtonConfig()
        
        viewModel.getPost(isInitialCall: true) { error in
            if let error = error {
                if error == .tokenExpired {
                    self.tokenExpired()
                } else {
                    return
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func navBarConfig() {
        title = "새싹농장"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        let navBar = self.navigationController?.navigationBar
        navBar?.prefersLargeTitles = true
        
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.compactScrollEdgeAppearance = appearance

    }
    
    private func tableViewConfig() {
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
        
        tableView.register(FirstRowCell.self, forCellReuseIdentifier: FirstRowCell.identifier)
        tableView.register(SecondRowCell.self, forCellReuseIdentifier: SecondRowCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.sectionFooterHeight = 2
        tableView.sectionHeaderHeight = 0
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .systemGreen
        tableView.refreshControl?.addTarget(self, action: #selector(refreshPost(_:)), for: .valueChanged)
        
    }
    
    private func plusButtonConfig() {
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        plusButton.layer.shadowRadius = 5
        plusButton.layer.shadowOpacity = 0.3
        
        plusButton.addTarget(self, action: #selector(writePost(_:)), for: .touchUpInside)

        view.addSubview(plusButton)

        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
    }
    
    @objc func writePost(_ sender: UIButton) {
        let writeVC = WritePostViewController()
        let nav = UINavigationController(rootViewController: writeVC)
        writeVC.modalPresentationStyle = .fullScreen
        writeVC.mainViewController = self
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func refreshPost(_ sender: UIRefreshControl) {
        
        viewModel.getPost(refresh: sender) { error in
            if let error = error {
                if error == .tokenExpired {
                    self.tokenExpired()
                } else {
                    return
                }
            }
        }
    }
}

extension MainPostViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
//        print("index = \(indexPaths.last!.section)\ntotalpost = \(viewModel.totalPost)\ncurrentpost = \(viewModel.post.value.count)\ncurrentpage = \(viewModel.currentPage)\n=====================")
        
        if viewModel.post.value.count < viewModel.totalPost {
            if indexPaths.last!.section == viewModel.post.value.count - 1 {
                viewModel.getPost(refresh: nil) { error in
                    if let error = error {
                        if error == .tokenExpired {
                            self.tokenExpired()
                        } else {
                            return
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.post.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 44
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModel.post.value.count - 1 { return 0 }
        return 10
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.post.value[indexPath.section]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailPostViewController()
        vc.mainPostViewModel = self.viewModel
        vc.mainPostViewController = self
        vc.viewModel.postId = viewModel.post.value[indexPath.section].id
        vc.viewModel.post.value = viewModel.post.value[indexPath.section]
        vc.viewModel.postIndex = indexPath.section
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
