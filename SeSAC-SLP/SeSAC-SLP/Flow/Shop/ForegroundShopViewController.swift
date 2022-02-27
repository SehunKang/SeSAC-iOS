//
//  ForegroundShopViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import UIKit
import StoreKit
import SnapKit
import MachO
import SkeletonView

class ForegroundShopViewController: UIViewController {
    
    var productIdentifier: Set<String> = ["com.memolease.sesac1.sprout1", "com.memolease.sesac1.sprout2", "com.memolease.sesac1.sprout3", "com.memolease.sesac1.sprout4"]

    var myItem = [1, 0, 0, 0, 0] {
        didSet {
            //귀찮아서 일단 이렇게..
            collectionView.reloadData()
        }
    }
    
    var productArray: Array<SKProduct>? {
        didSet {
            DispatchQueue.main.async {
                self.view.hideSkeleton()
            }
        }
    }
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        requestProductData()
        self.view.isSkeletonable = true
        collectionViewConfigure()
        self.view.showAnimatedGradientSkeleton()
    }
    
    private func collectionViewConfigure() {

//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(344)
        }
        collectionView.register(ForegroundCollectionViewCell.self, forCellWithReuseIdentifier: "ForegroundCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(280))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:  itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(8)
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
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
                let items = myInfo.sesacCollection
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

        let payment = SKPayment(product: productArray![index])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
}

extension ForegroundShopViewController: SKProductsRequestDelegate {
    
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

extension ForegroundShopViewController: SKPaymentTransactionObserver {
    
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

extension ForegroundShopViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productArray = productArray else {return 1}
        return productArray.count + 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForegroundCollectionViewCell", for: indexPath) as? ForegroundCollectionViewCell else {return UICollectionViewCell()}
        
        cell.imageView.image = UIImage(named: "sesac_face_\(indexPath.item)")

        if indexPath.item == 0 {
            cell.nameLabel.text = "기본 새싹"
            cell.discriptionLabel.text = "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
            cell.priceButton.setTitle("보유", for: .normal)
            cell.priceButton.setTitleColor(CustomColor.SLPGray7.color, for: .normal)
            cell.priceButton.backgroundColor = CustomColor.SLPGray2.color
        } else {
            guard let productArray = productArray else {return UICollectionViewCell()}
            let product = productArray[indexPath.item - 1]
            cell.nameLabel.text = product.localizedTitle
            cell.discriptionLabel.text = product.localizedDescription
            if myItem[indexPath.item] == 1 {
                cell.priceButton.setTitle("보유", for: .normal)
                cell.priceButton.setTitleColor(CustomColor.SLPGray7.color, for: .normal)
                cell.priceButton.backgroundColor = CustomColor.SLPGray2.color
            } else {
                cell.priceButton.setTitle("\(product.price)", for: .normal)
                cell.priceButton.setTitleColor(CustomColor.SLPWhite.color, for: .normal)
                cell.priceButton.backgroundColor = CustomColor.SLPGreen.color
            }
        }
        cell.priceButton.tag = indexPath.item
        cell.priceButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("foregroundClicked"), object: nil, userInfo: ["item": indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItem.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ForegroundCollectionViewCell"
    }
    
    
    
}

extension ForegroundShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.frame.width / 2) - 12
        let height: CGFloat = 280
        
        let size = CGSize(width: width, height: height)
        return size
    }
}
