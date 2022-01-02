//
//  EditCommentViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/02.
//

import Foundation
import UIKit

class EditCommentViewController: UIViewController {
    
    var viewModel: DetailPostViewModel!
    
    let textView = UITextView()
    
    var commentId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        textView.font = .systemFont(ofSize: 20)
        textView.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didEndEditing(_:)))
    }
    
    @objc private func didEndEditing(_ sender: UIBarButtonItem) {
        viewModel.editComment(commentId: commentId, text: textView.text, postId: viewModel.postId) { error in
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.viewModel.updateComment()
                }
            }
        }
    }
}
