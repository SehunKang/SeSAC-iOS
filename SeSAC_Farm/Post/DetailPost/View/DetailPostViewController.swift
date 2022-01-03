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
    let toolbar = UIToolbar()

    
    let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 330, height: 35))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        viewModel.getComment { error in
            if let error = error {
                self.tokenExpired()
            }
        }
        
        viewModel.comment.bind { comments in
            self.tableView.reloadSections(IndexSet(1...2), with: .none)
        }
        viewModel.post.bind { post in
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(editOrDelete))
        toolbarConfig()
        tableViewInit()
    }
    
    @objc func editOrDelete() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { action in
            let vc = WritePostViewController()
            vc.textField.text = self.viewModel.post.value.text
            vc.viewModel.postId = self.viewModel.postId
            vc.superViewModel = self.viewModel
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            
            self.present(nav, animated: true, completion: nil)
        }
        let delete = UIAlertAction(title: "삭제", style: .default) { action in
            let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { action in
                self.viewModel.deletePost { error in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func tableViewInit() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolbar.snp.top)
        }
        
        tableView.register(PostInfoCell.self, forCellReuseIdentifier: PostInfoCell.identifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(SecondRowCell.self, forCellReuseIdentifier: SecondRowCell.identifier)
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func toolbarConfig() {
        
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostInfoCell.identifier) as? PostInfoCell else {return UITableViewCell()}
                cell.nameLabel.text = viewModel.post.value.user.username
                cell.dateLabel.text = viewModel.post.value.updatedAt.dateFormat()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier) as? TextCell else {return UITableViewCell()}
                cell.mainTextLabel.text = viewModel.post.value.text
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SecondRowCell.identifier) as? SecondRowCell else {return UITableViewCell()}
            cell.commentLabel.text = "댓글 \(viewModel.comment.value.count)"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell else {return UITableViewCell()}
            cell.nameLabel.text = viewModel.comment.value[indexPath.row].user.username
            cell.commentLabel.text = viewModel.comment.value[indexPath.row].comment
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.button.tag = viewModel.comment.value[indexPath.row].id
            cell.button.addTarget(self, action: #selector(commentEdit(_:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func commentEdit(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { action in
            let vc = EditCommentViewController()
            vc.commentId = sender.tag
            vc.viewModel = self.viewModel
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.viewModel.deleteCommet(commentId: sender.tag) { error in
                if error == nil {
                    self.viewModel.getComment { error in
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [edit, delete, cancel].forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension DetailPostViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textfield.text, textfield.text != "" else { return }
        
        viewModel.writeComment(comment: text) { error in
            if let error = error {
                if error == .tokenExpired {
                    self.tokenExpired()
                } else {
                    return
                }
            } else {
                self.viewModel.getComment { error in
                }
            }
        }
    }
}
