//
//  temp.swift
//  TMDB_API_Prac
//
//  Created by Sehun Kang on 2021/12/24.
//

import Foundation
import UIKit
//shift + ctrl
//option + command + [] - 코드 옮기기
//Expand AutoComplete
//interface: ctrl cmd up
//중괄호 닫기 : option cmd < >
//shift + cmd + o: 파일이동
//block만들기 : < # # >
//키바인딩, 스니펫 저장 위치: ~/Library/Developer/Xcode/UserData

class TempViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var countryNameProperty = "storyboard"
        print(#function)
        print("hello")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    var array = [1, 2, 3]
    
    
    /// - parameters message: 메세지여
    /// - important this is important
    /// - returns returns
    /// - ososososososo
    ///   - one
    ///   - **bold**
    ///    - *lay*
    ///    - go to [here](https://www.apple.com)
    ///     - four
    ///         - six
    ///             - seven
    /// - five
    func welcome(message: String, completion: @escaping () -> Void) -> String {
        return ""
    }
}


class User {
    
    // opt + cmd + /
    /// <#Description#>
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - age: <#age description#>
    ///   - email: <#email description#>
    ///   - review: <#review description#>
    internal init(name: String, age: Int, email: String, review: Double) {
        self.name = name
        self.age = age
        self.email = email
        self.review = review
    }
    
    var name: String
    var age: Int
    var email: String
    var review: Double
    
}
