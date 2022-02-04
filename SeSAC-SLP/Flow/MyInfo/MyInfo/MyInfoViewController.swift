//
//  MyInfoViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/02.
//

import UIKit

class MyInfoViewController: UIViewController {
    
    static let identifier = "MyInfoViewController"
    
    private let viewModel = MyInfoViewModel()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "내 정보"
        tableViewConfig()
        navBarBackButtonConfigure()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
        
    private func tableViewConfig() {
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 96
        } else {
            return 74
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = viewModel.getCellItems()
        let images = viewModel.getCellImages()
        
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = titles[indexPath.row]
        if indexPath.row == 0 {
            content.textProperties.font = CustomFont.Title1_M16.font
        } else {
            content.textProperties.font = CustomFont.Title2_R16.font
        }
        content.textProperties.color = CustomColor.SLPBlack.color
        content.image = images[indexPath.row]
        cell.contentConfiguration = content
        
        if indexPath.row == 0 {
            cell.accessoryView = UIImageView(image: UIImage(named: "disclosure"))
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 15)
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.getUserData { code in
                switch code {
                case 200:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: MyInfoDetailViewController.identifier) as! MyInfoDetailViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                default:
                    self.errorHandler(with: code)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
