//
//  WritePostViewController.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/02.
//

import Foundation
import UIKit

class WritePostViewController: UIViewController {
    
    let viewModel = WritePostViewModel()
    var superViewModel: DetailPostViewModel!
    
    let textField = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        textFieldConfig()
    }
    
    func viewConfig() {
        
        view.backgroundColor = .systemBackground
        title = "새싹농장 글쓰기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didEndEditing(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(dismissView(_:)))
    }
    
    func textFieldConfig() {
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        textField.font = .systemFont(ofSize: 20)
        textField.becomeFirstResponder()
    }
    
    @objc func dismissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didEndEditing(_ sender: UIBarButtonItem) {
        guard viewModel.postId != nil else {
            viewModel.writePost(text: textField.text) { error in
                if error == nil {
                    let vm = MainPostViewModel()
                    self.dismiss(animated: true) {
                        vm.getPost { error in
                        }
                    }
                }
            }
            return
        }
        viewModel.editPost(text: textField.text) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.superViewModel.updatePost()
                    }
                }
            }
        }
    }

    
}
