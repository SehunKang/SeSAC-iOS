//
//  WebViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/18.
//

import UIKit

class WebViewController: UIViewController {

	var list: TvInfo?
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.title = list?.title
		print(list?.title)
	
    }
    
}
