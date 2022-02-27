//
//  WebViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/18.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

	var list: TvInfo?
	var destinationURL: String?
	
	@IBOutlet weak var webView: WKWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		openWebPage(to: destinationURL!)
		navigationItem.title = list?.title
		
    }
	
	func openWebPage(to urlStr: String) {
		guard let url = URL(string: urlStr) else {
			print("Invalid URL")
			return
		}
		let request = URLRequest(url:url)
		webView.load(request)
	}
    
}
