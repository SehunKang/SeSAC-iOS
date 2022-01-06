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
    var originalText: String!
    var commentId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        textView.font = .systemFont(ofSize: 20)
        textView.text = originalText
        textView.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didEndEditing(_:)))
    }
    
    @objc private func didEndEditing(_ sender: UIBarButtonItem) {
        //rx로 업데이트
        if originalText != textView.text {
            viewModel.editComment(commentId: commentId, text: textView.text, postId: viewModel.post.value.id) { error in
                DispatchQueue.main.async {
                    print("editcommentsent")
                    self.dismiss(animated: true) {
                        self.viewModel.updateComment()
                    }
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
