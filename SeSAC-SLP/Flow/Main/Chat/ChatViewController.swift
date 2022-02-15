//
//  ChatViewController.swift
//  SeSAC-SLP

//
//  Created by Sehun Kang on 2022/02/13.
//

import UIKit
import SnapKit
import Realm
import RxSwift
import RxCocoa

//struct ChatModel: Codable {
//
//    let payload: [Payload]
//}

class ChatViewController: UIViewController {
    
    static let identifer = "ChatViewController"
    
    let bag = DisposeBag()

    enum Section {
        case main
    }
    
    struct ChatItem: Hashable {
        let message: String
        let date: String
        let chatType: ChatCell.ChatType
        private let identifier = UUID()
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ChatItem>!
    var chatSnapshot = NSDiffableDataSourceSectionSnapshot<ChatItem>()
    
//    var data: [ChatItem] = [ChatItem(message: "hi", date: "15:02", chatType: .receive), ChatItem(message: "hello", date: "16:03", chatType: .send), ChatItem(message: "asdkfnakjsdfbnakjsdbflakjsdbflakjsdbflakjsbdflkjasbdflkjasbdlfkjasbdlfkjbalsjkdfbalksdjfbalksjdbflakjsdbflkadsjbflakjsdbflakjsdbflaksjdbflkasjdbfalksjdfbalksjdfbalsjkdfbalksdjfbklj", date: "16:09", chatType: .receive)]
    
    var uid: String! = "test"
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfigure()
        collectionViewConfigure()
        chatPreSet()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        SocketIOManager.shared.closeConnection()
    }
    
    
    
    private func uiConfigure() {
        
        containerView.layer.cornerRadius = 8
        textView.font = CustomFont.Body3_R14.font
        textView.delegate = self
        
        sendButton.setImage(UIImage(named: "send_inact"), for: .disabled)
        sendButton.setImage(UIImage(named: "send_act"), for: .normal)
        
    }
    
    private func collectionViewConfigure() {
        configureHierarchy()
        configureDataSource()
        snapshotSectionInit()
        snapshotItemInit()
    }
    
    private func bind() {
        textView.rx.text
            .orEmpty
            .map {$0.count > 1}
            .share(replay: 1, scope: .whileConnected)
            .bind(to: self.sendButton.rx.isEnabled)
            .disposed(by: bag)
        
        sendButton.rx.tap
            .subscribe { _ in
                self.postText()
            }
            .disposed(by: bag)
    
        
    }
    
    private func postText() {
        let resultData = Payload(__v: 0, _id: "test", chat: textView.text, createdAt: Date(), from: UserDefaultManager.userData!.uid, to: uid)
        
//        APIServiceForChat.sendChat(to: uid, text: textView.text) { result in
//            switch result {
//            case .success(let response):
//                guard let resultData = try? response.map(Payload.self) else {return}
                RealmService.shared.appendChatData(of: self.uid, payload: [resultData])
//                self.textView.text = ""
//            case .failure(let error):
//                self.errorHandler(with: error.errorCode)
//            }
//        }
//        chatSnapshot.append([ChatItem(message: resultData.chat, date: resultData.createdAt.timeFilter, chatType: .send)])
//        dataSource.apply(chatSnapshot, to: .main)
    }
    
}

extension ChatViewController {
    
    private func configureHierarchy() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaInsets)
            make.bottom.equalTo(containerView.snp.top).offset(-20)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let section: NSCollectionLayoutSection
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.bounds.width), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<ChatCell, ChatItem> {
        return UICollectionView.CellRegistration<ChatCell, ChatItem> { cell, indexPath, item in
            
            cell.model = .init(message: item.message, chatType: item.chatType, date: item.date)
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = cellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, ChatItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func snapshotSectionInit() {
        let section = [Section.main]
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatItem>()
        snapshot.appendSections(section)
        dataSource.apply(snapshot)
    }
    
    private func snapshotItemInit() {
        
//        let chatItem: [ChatItem] = data
//        chatSnapshot.append(chatItem)
//        dataSource.apply(chatSnapshot, to: .main)
    }
}

// 채팅이 시작되기 전의 채팅 세팅
extension ChatViewController {
    
    private func chatPreSet() {
        
        if RealmService.shared.isFirstChat(with: uid) {
            RealmService.shared.createNewChatData(of: uid)
        } else {
            getChatData()
        }
//        socketOn()
//        realmBind()

    }
    
    ///DB로부터 채팅상대(uid)에 대한 데이터를 먼저 가져오고 서버로부터 요청한다.
    private func getChatData() {
        
        let previousChatPayload = RealmService.shared.getAllChatData(from: uid)
        
        let items = payloadToItem(payload: previousChatPayload)
        chatSnapshot.append(items)
        
//        getRemainderChatDataFromServer()
    }
    
//    private func getRemainderChatDataFromServer() {
//        let lastChatDate = RealmService.shared.lastChatDate(with: uid)
//
//        APIServiceForChat.lastChat(to: uid, at: lastChatDate) { result in
//            switch result {
//            case .success(let response):
//                let resultData = try? response.map(ChatModel.self)
//                let items = self.payloadToItem(payload: resultData!.payload)
//                self.chatSnapshot.append(items)
//                self.dataSource.apply(self.chatSnapshot, to: .main)
//            case .failure(let error):
//                self.errorHandler(with: error.errorCode)
//            }
//        }
//    }

    private func socketOn() {
        
        SocketIOManager.shared.establishConnection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
    }

    
    @objc func getMessage(notification: NSNotification) {
        let __v = notification.userInfo!["__v"] as! Int
        let _id = notification.userInfo!["_id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String

        let value = Payload(__v: __v, _id: _id, chat: chat, createdAt: createdAt.toDate, from: from, to: to)
        
        RealmService.shared.appendChatData(of: uid, payload: [value])
        //넣어야대
    }
    
//    private func realmBind() {
//        let observable = RealmService.shared.realmBind(with: uid)
//
//        observable.subscribe { event in
//            guard let payload = event.element else {return}
//            let item = self.payloadToItem(payload: [payload])
//            self.chatSnapshot.append(item)
//            self.dataSource.apply(self.chatSnapshot, to: .main)
//        }
//        .disposed(by: bag)
//    }

    private func payloadToItem(payload: [Payload]) -> [ChatItem] {

        let myUid = UserDefaultManager.userData?.uid
        var items: [ChatItem] = []
        payload.forEach {
            let chat = $0.chat
            let type: ChatCell.ChatType
            if $0.from == myUid {
                type = .send
            } else {
                type = .receive
            }
            let date = $0.createdAt.timeFilter
            items.append(ChatItem(message: chat, date: date, chatType: type))
        }
        return items
        
    }

}

extension ChatViewController {
    
    
}

extension ChatViewController: UITextViewDelegate {
    
}
