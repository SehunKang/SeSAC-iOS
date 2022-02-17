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
import RealmSwift

struct ChatModel: Codable {

    let payload: [Payload]
}

class ChatViewController: UIViewController {
    
    static let identifer = "ChatViewController"
    
    let bag = DisposeBag()

    enum Section {
        case main
    }
    
    enum ChatType {
        case receive
        case send
    }
    
    struct ChatItem: Hashable {
        let message: String
        let date: String
        let chatType: ChatType
        private let identifier = UUID()
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ChatItem>!
    var chatSnapshot = NSDiffableDataSourceSectionSnapshot<ChatItem>()
    
//    var data: [ChatItem] = [ChatItem(message: "hi", date: "15:02", chatType: .receive), ChatItem(message: "hello", date: "16:03", chatType: .send), ChatItem(message: "asdkfnakjsdfbnakjsdbflakjsdbflakjsdbflakjsbdflkjasbdflkjasbdlfkjasbdlfkjbalsjkdfbalksdjfbalksjdbflakjsdbflkadsjbflakjsdbflakjsdbflaksjdbflkasjdbfalksjdfbalksjdfbalsjkdfbalksdjfbklj", date: "16:09", chatType: .receive)]
    
    var uid: String! = "test3"
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    var realmNotificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfigure()
        collectionViewConfigure()
        chatPreSet()
        bind()
        keyboardConfigure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        SocketIOManager.shared.closeConnection()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private func uiConfigure() {
        
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.layer.zPosition = 999
        textView.font = CustomFont.Body3_R14.font
        textView.delegate = self
        
        textView.snp.remakeConstraints { make in
            make.height.lessThanOrEqualTo(77)
        }
        
        sendButton.setImage(UIImage(named: "send_inact"), for: .disabled)
        sendButton.setImage(UIImage(named: "send_act"), for: .normal)
    }
    
    private func collectionViewConfigure() {
        configureHierarchy()
        configureDataSource()
        snapshotSectionInit()
    }
    
    private func bind() {
        textView.rx.text
            .orEmpty
            .map {$0.count > 0}
            .share(replay: 1, scope: .whileConnected)
            .bind(to: self.sendButton.rx.isEnabled)
            .disposed(by: bag)
        
        sendButton.rx.tap
            .subscribe {[unowned self] _ in
                postText()
//                textView.endEditing(true)
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
                self.textView.text = ""
//            case .failure(let error):
//                self.errorHandler(with: error.errorCode)
//            }
//        }
    }
    
    private func keyboardConfigure() {
        hideKeyboardOnTap()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let count = collectionView.numberOfItems(inSection: 0)
            var cellY = collectionView.cellForItem(at: IndexPath(item: count - 1, section: 0))?.frame.origin.y ?? self.collectionView.frame.maxY
            
            let textFieldHeight = 77.0
            let safeAreaHeight = self.view.frame.maxY - containerView.frame.maxY
            let keyboardAndTextFieldHeight = keyboardSize.height + textFieldHeight + safeAreaHeight - 16
            
            cellY = cellY > collectionView.frame.maxY ? collectionView.frame.maxY : cellY
                        
            if keyboardSize.height <= (self.view.frame.height - cellY - textFieldHeight) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -(keyboardSize.height - (safeAreaHeight - 16)))
                self.view.bringSubviewToFront(self.containerView)
            } else {
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: -(cellY - (self.view.frame.maxY - (keyboardAndTextFieldHeight + 16))))
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -(keyboardSize.height - (safeAreaHeight - 16)))
//                self.view.bringSubviewToFront(self.containerView)

            }
            
        }
    }
    
    @objc private func keyboardDown(_ notification: NSNotification) {
        self.containerView.transform = .identity
        self.collectionView.transform = .identity

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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<ChatCellSend, ChatItem> {
        return UICollectionView.CellRegistration<ChatCellSend, ChatItem> { cell, indexPath, item in
            
            cell.messageTextView.text = item.message
            cell.timeLabel.text = item.date
        }
    }
    
    private func receivedCellRegistration() -> UICollectionView.CellRegistration<ChatCellReceived, ChatItem> {
        return UICollectionView.CellRegistration<ChatCellReceived, ChatItem> { cell, indexPath, item in
            
            cell.messageTextView.text = item.message
            cell.timeLabel.text = item.date
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = cellRegistration()
        let receivedCellRegistration = receivedCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, ChatItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            if itemIdentifier.chatType == .send {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: receivedCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
    }
    
    private func snapshotSectionInit() {
        let section = [Section.main]
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatItem>()
        snapshot.appendSections(section)
        dataSource.apply(snapshot)
    }
    
}

// 채팅이 시작되기 전의 채팅 세팅
extension ChatViewController {
    
    private func chatPreSet() {
        
        if RealmService.shared.isFirstChat(with: uid) {
            RealmService.shared.createNewChatData(of: uid)
        }
//        getChatDataFromServer()
//        socketOn()
        realmBind()

    }
    
    private func getChatDataFromServer() {
        let lastChatDate = RealmService.shared.lastChatDate(with: uid)

        APIServiceForChat.lastChat(to: uid, at: lastChatDate) { result in
            switch result {
            case .success(let response):
                guard let resultData = try? response.map(ChatModel.self) else {return}
                RealmService.shared.appendChatData(of: self.uid, payload: resultData.payload)
            case .failure(let error):
                self.errorHandler(with: error.errorCode)
            }
        }
    }

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
    }
    
    private func realmBind() {
        guard let object = RealmService.shared.realm.objects(ChatData.self).filter("uid == %@", uid!).first?.payload else { return }
        
        realmNotificationToken = object.observe {[unowned self] change in
            switch change {
            case .initial(let result):
                let items = self.payloadToItem(payload: Array(result))
                chatSnapshot.append(items)
                dataSource.apply(chatSnapshot, to: .main)
                collectionView.scrollToItem(at: IndexPath(item: result.count - 1, section: 0), at: .bottom, animated: false)
            case .update(let result, let deletions ,let insertions, let modifications):
                if deletions.count > 0 {
                    print("deletion")
                }
                if insertions.count > 0 {
                    let payload = result.last!
                    let item = payloadToItem(payload: [payload])
                    chatSnapshot.append(item)
                    dataSource.apply(chatSnapshot, to: .main)
                    if payload.to == uid {
                        collectionView.scrollToItem(at: IndexPath(item: result.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }
                if modifications.count > 0 {
                    print("modification")
                }
            case .error(let error):
                print(error as Any)
            }
        }
    
    }

    private func payloadToItem(payload: [Payload]) -> [ChatItem] {

        let myUid = UserDefaultManager.userData?.uid
        var items: [ChatItem] = []
        payload.forEach {
            let chat = $0.chat
            let type: ChatType
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

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    func textViewDidChange(_ textView: UITextView) {
        let numberOfLines = Int((textView.contentSize.height / textView.font!.lineHeight))
        
        //3줄에서 2줄로 넘어갈때 1줄 높이가 되는 버그가 있음
        if numberOfLines > 2 {
            textView.isScrollEnabled = true
            textView.snp.remakeConstraints { make in
                make.height.equalTo(77)
            }
        } else {
            textView.isScrollEnabled = false
            textView.snp.remakeConstraints { make in
                make.height.lessThanOrEqualTo(77)
            }
        }
    }
}
