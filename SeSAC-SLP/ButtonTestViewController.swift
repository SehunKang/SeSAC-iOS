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
    @IBOutlet weak var dis: FilledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        dis.isEnabled = false
        inact.isSelected = true

    }
    

}
