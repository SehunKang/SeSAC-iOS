//
//  AroundViewController.swift
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

class AroundViewController: UIViewController {
    
    static let identifier = "AroundViewController"
    
    let disposeBag = DisposeBag()
    
    enum Section {
        case main
    }
    
    static let badgeElementKind = "badge-element-kind"
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.labelMainTitle.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        view.labelSubTitle.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        return view
    }()
    
    //완료 하고 FromQueueDB hashable 바꿔줄까?
    var dataSource: UICollectionViewDiffableDataSource<Section, FromQueueDB>! = nil
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, FromQueueDB>()

    
//    let data = [FromQueueDB(uid: "aabc", nick: "nick", lat: 10, long: 10, reputation: [0,0,0,0,0,0,0,0], hf: ["hobby1", "hobby2", "hobby3", "hobby4", "hobby5", "hobby6"], reviews: ["good", "very good"], gender: 0, type: 0, sesac: 0, background: 0), FromQueueDB(uid: "aabcds", nick: "nick", lat: 10, long: 10, reputation: [4,0,1,0,2,0,3,0], hf: ["hobby1", "hobby2", "hobby3", "hobby4", "hobby5", "hobby6"], reviews: ["goodasdklfnk\nasdklfnmalksdnf\nalmsnkdfnalksd\nanklsdfnlaksdfn\nalkdnsflkasndflkdsa\nalnskdfnalskdfnaslkdfnskla", "very good"], gender: 0, type: 0, sesac: 0, background: 0), FromQueueDB(uid: "aabcaasdds", nick: "nick", lat: 10, long: 10, reputation: [4,0,1,0,2,0,3,0], hf: ["hobby1", "hobby2", "hobby3", "hobby4", "hobby5", "hobby6"], reviews: [], gender: 0, type: 0, sesac: 0, background: 0)]
//    let data: [FromQueueDB] = []
    
    lazy var data: [FromQueueDB] = UserDefaultManager.queueData!.fromQueueDB {
        didSet {
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([.main])
            }
            snapshot.deleteItems(oldValue)
            snapshot.appendItems(data, toSection: .main)
            dataSource.apply(snapshot)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        backgroundBind()
        collectionView.delegate = self
        refreshQueue()
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
    
    private func refreshQueue() {
        let dataForOnQueue = APIServiceForSearch.getOnQueueData()

        APIServiceForSearch.onQueue(data: dataForOnQueue) { result in
            switch result {
            case .success(let response):
                let resultData = try? response.map(QueueData.self)
                self.data = resultData!.fromQueueDB
            case .failure(let error):
                if error.errorCode == 401 {
                    self.refreshToken {
                        self.refreshQueue()
                    }
                } else {
                    self.errorHandler(with: error.errorCode)
                }
            }
        }
    }
    
    private func sendRequest(_ cardIndex: Int) {
        
        let dataForAPI = ["otheruid": data[cardIndex].uid]
        APIServiceForSearch.hobbyRequest(data: dataForAPI) { result in
            
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    self.view.makeToast("취미 함께 하기 요청을 보냈습니다")
                case 201:
                    self.hobbyAccept(dataForAPI)
                case 202:
                    self.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다.")
                default: return
                }
            case .failure(let error):
                if error.errorCode == 401 {
                    self.refreshToken {
                        self.sendRequest(cardIndex)
                    }
                } else {
                    self.errorHandler(with: error.errorCode)
                }
            }
        }
    }
    
    private func hobbyAccept(_ apiData: [String: String]) {
        
        APIServiceForSearch.hobbyAccept(data: apiData) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    self.view.makeToast("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다", duration: 1, position: .center, style: ToastManager.shared.style) {_ in
                        print("go to chat")
                    }
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
                if error.errorCode == 401 {
                    self.refreshToken {
                        self.hobbyAccept(apiData)
                    }
                } else {
                    self.errorHandler(with: error.errorCode)
                }
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
                if error.errorCode == 401 {
                    self.refreshToken {
                        self.checkMyState()
                    }
                } else {
                    self.errorHandler(with: error.errorCode)
                }
            }
        }
    }


}

extension AroundViewController {
    
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

extension AroundViewController {
    
    private func configureHierarchy() {
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            //navbar, tabmanbar height을 합친 값... 이렇게 해야되나..?
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
        print(sender.tag)
        
        
        showPopUp(title: "취미 같이 하기를 요청할게요",
                  message: "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요", rightActionCompletion:  {
            self.sendRequest(sender.tag)
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
            dataInit()
        }
    }
    
    func dataInit() {
        
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)

    }
}

extension AroundViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //한 셀만 선택 가능하게
//        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
//            collectionView.deselectItem(at: indexPath, animated: true)
//        } else {
//            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
//        }
        //근데 왜 위와 같은 결과?? collectionView.allowsMultipleSelection 메서드를 건드려야 되는데 하니까 이상해짐..
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

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences:  true, completion: completion)
    }
}
