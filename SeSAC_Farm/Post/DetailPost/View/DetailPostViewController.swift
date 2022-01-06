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
    var mainPostViewModel: MainPostViewModel!
    var mainPostViewController: UIViewController!
    
    let tableView = UITableView()
    let toolbar = UIToolbar()
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .systemBackground
        
        viewModel.getComment { error in
            if error != nil {
                self.tokenExpired()
            }
        }
        
        viewModel.comment.bind { comments in
            self.tableView.reloadSections(IndexSet(1...2), with: .none)
        }
        viewModel.post.bind { post in
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        if viewModel.post.value.user.id == g_userId {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(editOrDelete))
        }
        toolbarConfig()
        tableViewInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        
//        print("tableView content: ",tableView.contentSize.height)
//        print("table view: ", tableView.frame.height)
//        print("screen: ", UIScreen.main.bounds.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.getOnePost { error in
            if error != nil {
                print("error")
            }
            self.mainPostViewModel.post.value[self.viewModel.postIndex] = self.viewModel.post.value
        }
    }
    
    @objc func editOrDelete() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { action in
            let vc = WritePostViewController()
            vc.textField.text = self.viewModel.post.value.text
            vc.viewModel.postId = self.viewModel.post.value.id
            vc.superViewModel = self.viewModel
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            
            self.present(nav, animated: true, completion: nil)
        }
        let delete = UIAlertAction(title: "삭제", style: .default) { action in
            let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { action in
                self.viewModel.deletePost { error in
                    popCallBack(from: self) {
                        let vc = self.mainPostViewController as! MainPostViewController
                        vc.refreshPost(UIRefreshControl())
                    }
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
            make.bottom.equalTo(textView.snp.top)
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
        
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGreen.cgColor
        textView.delegate = self
        textView.font = .systemFont(ofSize: 20)
        textView.text = "댓글을 입력해 주세요"
        textView.textColor = .lightGray
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = true
//        let textitem = UIBarButtonItem.init(customView: textView)
//        toolbar.items = [flexible, textitem, flexible]
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(55)
        }
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.bottom.equalTo(toolbar.snp.top)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(44)
        }
    }
    
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostInfoCell.identifier, for: indexPath) as? PostInfoCell else {return UITableViewCell()}
                cell.nameLabel.text = viewModel.post.value.user.username
                cell.dateLabel.text = viewModel.post.value.updatedAt.dateFormat()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier, for: indexPath) as? TextCell else {return UITableViewCell()}
                cell.mainTextLabel.text = viewModel.post.value.text
                cell.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SecondRowCell.identifier, for: indexPath) as? SecondRowCell else {return UITableViewCell()}
            cell.commentLabel.text = "댓글 \(viewModel.comment.value.count)"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {return UITableViewCell()}
            cell.nameLabel.text = viewModel.comment.value[indexPath.row].user.username
            cell.commentLabel.text = viewModel.comment.value[indexPath.row].comment
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.button.tag = indexPath.row
            cell.button.addTarget(self, action: #selector(commentEdit(_:)), for: .touchUpInside)
            if viewModel.comment.value[indexPath.row].user.id != g_userId {
                cell.button.isHidden = true
            } else {
                cell.button.isHidden = false
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func commentEdit(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { action in
            let vc = EditCommentViewController()
            vc.commentId = self.viewModel.comment.value[sender.tag].id
            vc.originalText = self.viewModel.comment.value[sender.tag].comment
            vc.viewModel = self.viewModel
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.viewModel.deleteCommet(commentId: self.viewModel.comment.value[sender.tag].id) { error in
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

extension DetailPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .label
        }
//        let bottomOffset = CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.size.height)
//        tableView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text, textView.text != "" else { return }
        
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
            textView.text = "댓글을 입력해 주세요"
            textView.textColor = .lightGray
        }
    }
}


//extension DetailPostViewController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        becomeFirstResponder()
//    }
//
//
//    override var inputAccessoryView: UIView? {
//        get {
//            let containerView = UIView()
//            containerView.backgroundColor = .lightGray
//            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//            let textView = UITextView()
//            containerView.addSubview(textView)
//            textView.backgroundColor = .systemBackground
//            textView.layer.cornerRadius = 25
//            textView.layer.masksToBounds = true
//            textView.layer.borderWidth = 2
//            textView.layer.borderColor = UIColor.systemGreen.cgColor
//            textView.snp.makeConstraints { make in
//                make.leading.equalTo(containerView.snp.leading).offset(20)
//                make.top.equalTo(containerView.snp.top).offset(5)
//                make.trailing.equalTo(containerView.snp.trailing).offset(-60)
//                make.height.equalTo(44)
//            }
//
//            let button = UIButton()
//            containerView.addSubview(button)
////            button.frame.size = CGSize(width: 44, height: 44)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.setTitle("", for: .normal)
//            button.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
//            button.snp.makeConstraints { make in
//                make.centerY.equalTo(textView)
//                make.leading.equalTo(textView.snp.trailing).offset(5)
//            }
//
//
//            return containerView
//        }
//    }
//
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    override var canResignFirstResponder: Bool {
//        return true
//    }
//}
