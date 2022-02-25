//
//  BackgroundShopViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import UIKit
import StoreKit
import SnapKit


class BackgroundShopViewController: UIViewController {

    var productIdentifier: Set<String> =  ["com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4", "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]

    var myItem = [1, 0, 0, 0, 0, 0, 0, 0] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var productArray: Array<SKProduct>! {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewConfigure()
            }
        }
    }
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        requestProductData()
//        collectionViewConfigure()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    private func collectionViewConfigure() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(344)
        }
        collectionView.register(BackgroundCollectionViewCell.self, forCellWithReuseIdentifier: "BackgroundCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    
    private func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifier as Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("IAP 에러")
        }
    }
    
    private func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        APIServiceForShop.validate(receipt: receiptString!, productIdentifier: productIdentifier) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case 200:
                self.updateInfo()
            case 201:
                self.view.makeToast("잘못된 경로입니다.")
            case 401:
                self.refreshToken {
                    self.receiptValidation(transaction: transaction, productIdentifier: productIdentifier)
                }
            default:
                self.errorHandler(with: result)
            }
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        
    }
    
    private func updateInfo() {
        APIServiceForShop.myInfo {[weak self] (myInfo, result) in
            guard let self = self else {return}
            if let myInfo = myInfo {
                let items = myInfo.backgroundCollection
                for item in items {
                    self.myItem[item] = 1
                }
            } else {
                if result == 401 {
                    self.refreshToken {
                        self.updateInfo()
                    }
                } else {
                    self.errorHandler(with: result!)
                }
            }
        }
    }
    
    @objc private func buttonClicked(_ sender: UIButton) {
        if myItem[sender.tag] == 1 {
            return
        }
        let index = sender.tag - 1

        NotificationCenter.default.post(name: NSNotification.Name("isOnActivityIndicator"), object: nil, userInfo: ["isOn": true])
        
        let payment = SKPayment(product: productArray[index])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
        
    }


}

extension BackgroundShopViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        productArray = products
//        if products.count > 0 {
//            for i in products {
//                productArray.append(i)
//            }
//        } else {
//            print("no product found")
//        }
        updateInfo()

    }
    
    
}

extension BackgroundShopViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove transaction")
        NotificationCenter.default.post(name: NSNotification.Name("isOnActivityIndicator"), object: nil, userInfo: ["isOn": false])
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
            case .failed:
                print("transaction failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

extension BackgroundShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundCollectionViewCell", for: indexPath) as? BackgroundCollectionViewCell else {return UICollectionViewCell()}
        cell.imageView.image = UIImage(named: "sesac_background_\(indexPath.item)")

        if indexPath.item == 0 {
            cell.nameLabel.text = "하늘 공원"
            cell.discriptionLabel.text = "새싹들을 많이 마주치는 매력적인 하늘 공원입니다."
            cell.priceButton.setTitle("보유", for: .normal)
            cell.priceButton.setTitleColor(CustomColor.SLPGray7.color, for: .normal)
            cell.priceButton.backgroundColor = CustomColor.SLPGray2.color
        } else {
            cell.nameLabel.text = productArray[indexPath.item - 1].localizedTitle
            cell.discriptionLabel.text = productArray[indexPath.item - 1].localizedDescription
            if myItem[indexPath.item] == 1 {
                cell.priceButton.setTitle("보유", for: .normal)
                cell.priceButton.setTitleColor(CustomColor.SLPGray7.color, for: .normal)
                cell.priceButton.backgroundColor = CustomColor.SLPGray2.color
            } else {
                cell.priceButton.setTitle("\(productArray[indexPath.item - 1].price)", for: .normal)
                cell.priceButton.setTitleColor(CustomColor.SLPWhite.color, for: .normal)
                cell.priceButton.backgroundColor = CustomColor.SLPGreen.color
            }
        }
        cell.priceButton.tag = indexPath.item
        cell.priceButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)

            
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("backgroundClicked"), object: nil, userInfo: ["item": indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    
    
}

extension BackgroundShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 165
        
        let size = CGSize(width: width, height: height)
        return size
    }
}

