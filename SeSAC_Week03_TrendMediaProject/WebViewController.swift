//
//  WebViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/18.
//

import UIKit

class WebViewController: UIViewController {

	var list: TvShow?
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.title = list?.title
		print(list?.title)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
