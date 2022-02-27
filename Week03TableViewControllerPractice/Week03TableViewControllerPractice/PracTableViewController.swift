//
//  PracTableViewController.swift
//  Week03TableViewControllerPractice
//
//  Created by Sehun Kang on 2021/10/12.
//

import UIKit

class PracTableViewController: UITableViewController {

	
	var list: [[String]] = [["공지사항", "실험실", "버전정보"], ["개인/보안", "알림", "채팅", "멀티프로필"], ["고객센터/도움말"]]
	
	var sectionList: [String] = ["전체 설정", "개인 설정", "기타"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		overrideUserInterfaceStyle = .dark
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list[section].count
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		return sectionList[section]
	}
	
//	****** Header의 각종 설정값을 주는 방법
//	1. 안에 UILabel을 만들어주는 듯
//	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let myLabel = UILabel()
//		myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 60)
//		myLabel.font = .systemFont(ofSize: 20)
//		myLabel.textColor = .gray
//		myLabel.text = sectionList[section]
//		let headerView = UIView()
//		headerView.addSubview(myLabel)
//
//		return headerView
//	}
//	2. class type 변환을 통한 방법.. 신박함
//	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//		guard let header = view as? UITableViewHeaderFooterView else { return } //*********** as?를 통해 class type (하위로)변환
//		header.textLabel?.font = .systemFont(ofSize: 20)
//	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = UITableViewCell()
		
		cell.textLabel?.text = list[indexPath.section][indexPath.row]
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = .systemFont(ofSize: 17)
		
		return cell
	}
	

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
