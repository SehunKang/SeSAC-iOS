//
//  DetailPostViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation
import UIKit
import SnapKit

class DetailPostViewController: UIViewController {
    
    let viewModel = DetailPostViewModel()
    
    let tableView = UITableView()
    
    let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 330, height: 35))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        viewModel.getComment { error in
            if let error = error {
                print(error)
//                DispatchQueue.main.async {
//                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: InitialViewController())
//                    windowScene.windows.first?.makeKeyAndVisible()
//                }
                tokenExpired(currentViewController: self)
            }
        }
        
        viewModel.comment.bind { comments in
            self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
        
        tableViewInit()
        toolbarConfig()
    }
    
    
    private func tableViewInit() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(PostInfoCell.self, forCellReuseIdentifier: PostInfoCell.identifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(SecondRowCell.self, forCellReuseIdentifier: SecondRowCell.identifier)
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func toolbarConfig() {
        
        let toolbar = UIToolbar()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        textfield.layer.cornerRadius = 10
        textfield.backgroundColor = .systemGroupedBackground
        textfield.placeholder = "  댓글을 입력해주세요"
        textfield.delegate = self
        let textitem = UIBarButtonItem.init(customView: textfield)
        toolbar.items = [flexible, textitem, flexible]
        toolbar.backgroundColor = .systemBackground
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 1
        case 2: return viewModel.numberOfComment
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postData = viewModel.post!
        let commentData = viewModel.comment.value
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostInfoCell.identifier) as? PostInfoCell else {return UITableViewCell()}
                cell.nameLabel.text = postData.user.username
                cell.dateLabel.text = postData.updatedAt.dateFormat()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier)!
                cell.textLabel?.text = postData.text
                return cell
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SecondRowCell.identifier) as? SecondRowCell else {return UITableViewCell()}
            cell.commentLabel.text = "댓글 \(postData.comments.count)"
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell else {return UITableViewCell()}
            cell.nameLabel.text = commentData[indexPath.row].user.username
            cell.commentLabel.text = commentData[indexPath.row].comment
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension DetailPostViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textfield.text, textfield.text != "" else { return }
        
        viewModel.writeComment(comment: text) { error in
            print("write")
            if let error = error {
                if error == .tokenExpired {
                    tokenExpired(currentViewController: self)
                } else {
                    return
                }
            } else {
                self.viewModel.getComment { error in
                    print(error as Any)
                }
            }
        }
    }
}
