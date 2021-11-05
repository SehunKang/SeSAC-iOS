//
//  CalendarViewController.swift
//  SeSAC_Week06
//
//  Created by Sehun Kang on 2021/11/05.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

	@IBOutlet weak var calendarView: FSCalendar!
	@IBOutlet weak var allCountLabel: UILabel!
	
	let localRealm = try! Realm()
	
	var tasks: Results<UserDiary>!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		calendarView.delegate = self
		calendarView.dataSource = self

		tasks = localRealm.objects(UserDiary.self)
		
//		let allCount = localRealm.objects(UserDiary.self).count
		let allCount = getAllDiaryCountFromUserDiary()
		allCountLabel.text = "총 \(allCount)개를 썼다"
		
//		let recent = localRealm.objects(UserDiary.self).sorted(by: "writeDate", ascending: false).first?.diaryTitle
//		print(recent)
//		let full = localRealm.objects(UserDiary.self).filter("content != nil").count
//		print(full)
//		let favorite = localRealm.objects(UserDiary.self).filter("favorite == false")
//		print(favorite)
//		//String -> ' ', AND OR
//		let search = localRealm.objects(UserDiary.self).filter("diaryTitle = '일기' AND content == 'lorem'")
//		print(search)
    }

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
	
//	func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//		return "title"
//	}
//
//	func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//		return "subtitle"
//	}
//	func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//		return UIImage(systemName: "star")
//	}
	//Date: 시분초까지 모두 동일해야 함.
	//1. 영국 표준시 기준으로 표기 : 2021-11-27 15:00:00 +0000 -> 11/28
	//2. 데이트포매터
	func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//		let format = DateFormatter()
//		format.dateFormat = "yyyyMMdd"
//		let test = "20211103"
//
//		if format.date(from: test) == date {
//			return 3
//		} else {
//			return 1
//		}
		//11.2 3개 이상의 일기라면 3개, 없다면 X, 1개면 1개
		
		return tasks.filter("writeDate == %@", date).count
	}
	
//	didsel
}
