//
//  RequestReceivedViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/08.
//

import UIKit
import SnapKit
import Tabman
import RxSwift
import RxCocoa
import Toast

class RequestReceivedViewController: UIViewController {
    
    static let identifier = "RequestReceivedViewController"
    
    let disposeBag = DisposeBag()
    
    enum Section {
        case main
    }
    
    static let badgeElementKind = "badge-element-kind"
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.labelMainTitle.text = "아직 받은 요청이 없어요ㅠ"
        view.labelSubTitle.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, FromQueueDB>! = nil

    var data: [FromQueueDB] = UserDefaultManager.queueData!.fromQueueDBRequested {
        didSet {
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([.main])
            }
            snapshot.deleteItems(oldValue)
            snapshot.appendItems(data, toSection: .main)
            dataSource.apply(snapshot)
        }
    }
    var snapshot = NSDiffableDataSourceSnapshot<Section, FromQueueDB>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        backgroundBind()
        collectionView.delegate = self
        refreshQueue()

    }
    
    private func backgroundBind() {
        backgroundView.buttonChangeHobby.rx.tap
            .subscribe { _ in
                self.changeHobby()
            }
            .disposed(by: disposeBag)

        backgroundView.buttonRefresh.rx.tap
            .throttle(.seconds(5), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.refreshQueue()
            }
            .disposed(by: disposeBag)
    }

    private func changeHobby() {
        APIServiceForSearch.delete { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    UserDefaultManager.userStatus = UserStatus.normal.rawValue
                    self.navigationController?.popViewController(animated: true)
                case 201:
                    self.view.makeToast("누군가와 취미를 함께하기로 약속하셨어요!")
                    print("채팅화면으로 이동")
                default: return
                }
            case .failure(let error):
                print(error.errorDescription as Any)
            }
        }
    }
    
    private func refreshQueue() {
        let dataForOnQueue = APIServiceForSearch.getOnQueueData()

        APIServiceForSearch.onQueue(data: dataForOnQueue) { result in
            switch result {
            case .success(let response):
                let resultData = try? response.map(QueueData.self)
                self.data = resultData!.fromQueueDBRequested
            case .failure(let error):
                self.errorHandler(with: error.errorCode)
            }
        }
    }
    
    private func hobbyAccept(index: Int) {
        let uid = data[index].uid
        let dataForAPI = ["otheruid": uid]
        
        APIServiceForSearch.hobbyAccept(data: dataForAPI) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    UserDefaultManager.userStatus = UserStatus.doneMatching.rawValue
                    print("goto cahat")
                case 201:
                    self.view.makeToast("상태방이 이미 다른 사람과 취미를 함께하는 중입니다.")
                case 202:
                    self.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다.")
                case 203:
                    self.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!", duration: 1, position: .center, style: ToastManager.shared.style) { _ in
                        self.checkMyState()
                    }
                default: return
                }
            case .failure(let error):
                self.errorHandler(with: error.errorCode)
            }
        }
    }
    
    private func checkMyState() {
        
        APIServiceForSearch.myQueueState { result in
            switch result {
            case .success(let response):
                let responseData = try? response.map(MyQueueStatus.self)
                switch response.statusCode {
                case 200:
                    if responseData?.matched == 1 {
                        self.view.makeToast("채팅방으로 이동합니다.", duration: 1, position: .center, style: ToastManager.shared.style) {_ in
                            print("goto chat")
                        }
                    }
                case 201:
                    self.view.makeToast("오랜 시간 동안 매칭 되지 않아 새싹 친구찾기를 그만둡니다.", duration: 1, position: .center, style: ToastManager.shared.style) {_ in
                        UserDefaultManager.userStatus = UserStatus.normal.rawValue
                        self.goHome()
                    }
                default: return
                }
            case .failure(let error):
                self.errorHandler(with: error.errorCode)
            }
        }
    }



}

extension RequestReceivedViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], absoluteOffset: CGPoint(x: -20, y: 20))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(40))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: AroundViewController.badgeElementKind, containerAnchor: badgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(252))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


extension RequestReceivedViewController {
    
    private func configureHierarchy() {
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(138)
            make.bottom.equalToSuperview().inset(34)
        }
        collectionView.layoutIfNeeded()

        collectionView.backgroundView = backgroundView
        
        if data.isEmpty {
            collectionView.backgroundView?.isHidden = false
        } else {
            collectionView.backgroundView?.isHidden = true
        }
    }
    
    @objc func badgeClicked(sender: UIButton) {
        
        showPopUp(title: "취미 같이 하기를 수락할까요?", message: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요", rightActionCompletion:  {
            self.hobbyAccept(index: sender.tag)
        })
    }
    
    
    
    func configureDataSource() {
        let badgeRegistration = UICollectionView.SupplementaryRegistration<BadgeView>(elementKind: BadgeView.reuseIdentifier) { supplementaryView, elementKind, indexPath in
            
            supplementaryView.badge.setAttributedTitle(NSAttributedString(string: "요청하기", attributes: [NSAttributedString.Key.font: CustomFont.Title3_M14.font, NSAttributedString.Key.foregroundColor: CustomColor.SLPWhite.color]), for: .normal)
            supplementaryView.badge.backgroundColor = CustomColor.SLPError.color
            supplementaryView.badge.tag = indexPath.item
            supplementaryView.badge.addTarget(self, action: #selector(self.badgeClicked(sender:)), for: .touchUpInside)
            
        }

        dataSource = UICollectionViewDiffableDataSource<Section, FromQueueDB>(collectionView: collectionView){ (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
                fatalError()
            }
            cell.data = itemIdentifier
            cell.imageView.image = UIImage(named: "sesac_background_\(itemIdentifier.background)")
            cell.sesacImageView.image = UIImage(named: "sesac_face_\(itemIdentifier.sesac)")
            return cell
        }
        
        dataSource.supplementaryViewProvider = {
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: badgeRegistration, for: $2)
        }
        
        collectionView.dataSource = dataSource

        
        if snapshot.numberOfSections == 0 {
            snapshot.appendSections([.main])
            snapshot.appendItems(data)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension RequestReceivedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        if collectionView.cellForItem(at: indexPath)?.isSelected == true {
            collectionView.deselectItem(at: indexPath, animated: true)
            refreshQueue()
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }

        dataSource.refresh()
        return false
    }
}
