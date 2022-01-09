//
//  ViewController.swift
//  IAP_Prac
//
//  Created by Sehun Kang on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var productIdentifier: Set<String> = ["Cookie10", "Cookie49", "Cookie100", "Cookie175", "Cookie250", "Cookie325", "Nonconsumable"]
    
    var productArray = Array<SKProduct>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestProductData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //어디에서 동기화해야될지 모르겠어서 일단
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.reloadData()
        }
        UserDefaults.standard.rx
            .observe(Int.self, "cookieCount")
            .subscribe { value in
                let num = value.element! ?? 0
                self.headerLabel.text = "현재 보유 쿠키 = \(num)"
            }
            .disposed(by: disposeBag)
        
        // 어떻게 특정 셀에서 변화를 감지하게 해야할지 모르겠다.
        UserDefaults.standard.rx
            .observe(Bool.self, "nonConsumable")
            .subscribe { value in
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func buyButtonClicked(_ sender: UIButton) {
        let index = sender.tag
        print(index)
        let payment = SKPayment(product: productArray[index])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
    func requestProductData() {
        
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: self.productIdentifier as Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("In-App purchase not available")
        }
    }
    
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(receiptString!)
        SKPaymentQueue.default().finishTransaction(transaction)
        let product = transaction.payment.productIdentifier
        if let number = Int(product.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            let count = UserDefaults.standard.integer(forKey: "cookieCount")
            let newCount = count + number
            UserDefaults.standard.set(newCount, forKey: "cookieCount")
            print("old = \(count), new = \(newCount)")
        } else {
            UserDefaults.standard.set(true, forKey: "nonConsumable")
        }

    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = productArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell()}
        cell.productLabel.text = product.productIdentifier
        cell.priceButton.tag = indexPath.row
        cell.priceButton.setTitle("\(product.price)", for: .normal)
        cell.priceButton.addTarget(self, action: #selector(buyButtonClicked(_:)), for: .touchUpInside)
        if product == productArray.last {
            cell.priceButton.isEnabled = !UserDefaults.standard.bool(forKey: "nonConsumable")
        }
        return cell
    }
    
}

extension ViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            for i in products {
                self.productArray.append(i)
            }
        } else {
            print("no product found")
        }
    }
}

extension ViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransaction")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                
//            case .purchasing:
//                <#code#>
            case .purchased:
                
                print("Transaction approved. Product identifier: \(transaction.payment.productIdentifier)")
                self.receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
            case .failed:
                print("Transaction failed")
                SKPaymentQueue.default().finishTransaction(transaction)
//            case .restored:
//                <#code#>
//            case .deferred:
//                <#code#>
            @unknown default:
                break
            }
        }
    }
    
    
}

