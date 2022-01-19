//
//  ButtonTestViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/18.
//

import UIKit

class ButtonTestViewController: UIViewController {
    
    
    @IBOutlet weak var inact: InactiveButton!
    @IBOutlet weak var fil: FilledButton!
    @IBOutlet weak var out: OutlineButton!
    @IBOutlet weak var canc: CancelButton!
    
    @IBOutlet weak var textfield: MyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        inact.isSelected = true
        textfield.successMessage = "success"
        textfield.errorMessage = "failed"
        

    }
    
    @IBAction func clicked(_ sender: Any) {
        textfield.isError = true
    }
    
    @IBAction func clickedSuc(_ sender: Any) {
        textfield.showSuccess()
    }
    
    @IBAction func `in`(_ sender: Any) {
        textfield.isEnabled = !textfield.isEnabled
    }
}
