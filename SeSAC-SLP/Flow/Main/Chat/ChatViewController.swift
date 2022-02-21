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
import Toast

struct ChatModel: Codable {

    let payload: [Chat]
}

struct Chat: Codable {
    let id: String
    let v: Int
    let to, from, chat, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case to, from, chat, createdAt
    }
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
    
    
    var uid: String! {
        didSet {
            chatPreSet()
        }
    }
    var matchedUser: String = "" {
        didSet {
            title = matchedUser
        }
    }
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var moreMenuStack: UIStackView!
    @IBOutlet weak var sirenButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    
    var realmNotificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uiConfigure()
        collectionViewConfigure()
        bind()
        keyboardConfigure()
        moreMenuConfigure()
        statusCheck()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SocketIOManager.shared.closeConnection()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private func uiConfigure() {
        
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.layer.zPosition = 1
        textView.font = CustomFont.Body3_R14.font
        textView.delegate = self
        
        textView.snp.remakeConstraints { make in
            make.height.lessThanOrEqualTo(77)
        }
        
        sendButton.setImage(UIImage(named: "send_inact"), for: .disabled)
        sendButton.setImage(UIImage(named: "send_act"), for: .normal)
        navBarBackButtonConfigure()
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis"), style: .plain, target: self, action: #selector(showMoreMenu) )
        let buttonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showMoreMenu))
        
        self.navigationItem.rightBarButtonItem = buttonItem

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
            .subscribe {[weak self] _ in
                self?.postText()
            }
            .disposed(by: bag)
    
        
    }
    
    private func postText() {
        
        APIServiceForChat.sendChat(to: uid, text: textView.text) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                print(response.statusCode)
                guard let resultData = try? response.map(Chat.self) else {print("failed post");return}
                RealmService.shared.appendChatData(of: self.uid, payload: [Payload(__v: resultData.v, _id: resultData.id, chat: resultData.chat, createdAt: resultData.createdAt.toDate, from: resultData.from, to: resultData.to)])
                self.textView.text = ""
            case .failure(let error):
                self.errorHandler(with: error.errorCode)
            }
        }
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
    
    private func moreMenuConfigure() {
        
        view.bringSubviewToFront(moreMenuStack)
        moreMenuStack.clipsToBounds = true
        [sirenButton, cancelButton, reviewButton].forEach { button in
            let font = CustomFont.Title3_M14.font
            let color = CustomColor.SLPBlack.color
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .top
            config.imagePadding = 6
            config.titleAlignment = .center
            config.baseForegroundColor = color
            switch button {
            case sirenButton:
                config.title = "새싹 신고"
                config.image = UIImage(named: "siren")
                button!.rx.tap.subscribe { [weak self] _ in
                    self?.report()
                }.disposed(by: bag)
            case cancelButton:
                config.title = "약속 취소"
                config.image = UIImage(named: "cancel_match")
                button!.rx.tap.subscribe { [weak self] _ in
                    self?.cancelMatch()
                }.disposed(by: bag)
            case reviewButton:
                config.title = "리뷰 등록"
                config.image = UIImage(named: "write")
                button!.rx.tap.subscribe { [weak self] _ in
                    self?.review()
                }.disposed(by: bag)
            default: return
            }
            button?.configuration = config
            button?.titleLabel?.font = font
            button?.backgroundColor = .systemBackground
        }
        moreMenuStack.transform = CGAffineTransform(translationX: 0, y: -200)
        moreMenuStack.spacing = 0
                
    }
    
    @objc private func showMoreMenu() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapWhenMoreMenu))
        UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews) {
            self.moreMenuStack.transform = .identity
        }
        view.addOverlay(yPosition: moreMenuStack.frame.maxY, tapGesture: tap )
        navigationItem.rightBarButtonItem?.isEnabled = false

    }
    
    @objc private func tapWhenMoreMenu() {
        view.removeOverlay()
        moreMenuStack.transform = CGAffineTransform(translationX: 0, y: -200)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func report() {
        let vc = ReportViewController(uid: uid)
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: false, completion: nil)
    }
    
    private func cancelMatch() {
        showPopUp(title: "약속을 취소하겠습니까?",
                  message: "약속을 취소하시면 페널티가 부과됩니다.", rightActionCompletion:  {
            APIServiceForChat.dodge(uid: self.uid) {[weak self] result in
                guard let self = self else {return}
                switch result {
                case 200:
                    UserDefaultManager.userStatus = UserStatus.normal.rawValue
                    self.goHome()
                case 201:
                    //이게 필요한가??
                    self.view.makeToast("잘못된 상대입니다.")
                case 401:
                    self.refreshToken {
                        self.cancelMatch()
                    }
                default:
                    self.errorHandler(with: result)
                }
            }
        })
    }
    
    private func review() {
        let vc = ReviewViewController(uid: uid, userName: matchedUser)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }

    
    private func statusCheck() {
        APIServiceForSearch.myQueueState {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let result = try? response.map(MyQueueStatus.self) else {return}
                    if result.dodged == 1 || result.reviewed == 1 {
                        self.view.makeToast("약속이 종료되어 채팅을 보낼 수 없습니다.", duration: 1, position: .center, style: ToastManager.shared.style) { _ in
                            self.navigationController?.popViewController(animated: true)
                            UserDefaultManager.userStatus = UserStatus.normal.rawValue
                        }
                    }
                    self.uid = result.matchedUid
                    self.matchedUser = result.matchedNick
                case 401:
                    self.statusCheck()
                default:
                    self.errorHandler(with: response.statusCode)
                }
            default: return
            }
        }
    }
    
}

extension ChatViewController {
    
    private func configureHierarchy() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
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
        realmBind()
        getChatDataFromServer()
        socketOn()

    }
    
    private func getChatDataFromServer() {
        let lastChatDate = RealmService.shared.lastChatDate(with: uid)

        APIServiceForChat.lastChat(to: uid, at: lastChatDate) { result in
            switch result {
            case .success(let response):
                guard let resultData = try? response.map(ChatModel.self) else {return}
                RealmService.shared.appendChatData(of: self.uid, payload: self.chatToPayload(chat: resultData.payload))
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
        
        realmNotificationToken = object.observe {[weak self] change in
            guard let self = self else {return}
            switch change {
            case .initial(let result):
                let items = self.payloadToItem(payload: Array(result))
                self.chatSnapshot.append(items)
                self.dataSource.apply(self.chatSnapshot, to: .main)
                self.scrollToLast()
            case .update(let result, let deletions ,let insertions, let modifications):
                if deletions.count > 0 {
                    print("deletion")
                }
                if insertions.count > 0 {
                    let payload = result.last!
                    let item = self.payloadToItem(payload: [payload])
                    self.chatSnapshot.append(item)
                    self.dataSource.apply(self.chatSnapshot, to: .main)
                    if payload.to == self.uid {
                        self.scrollToLast()
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
    
    private func chatToPayload(chat: [Chat]) -> [Payload] {
        let payload = chat.map {Payload(__v: $0.v, _id: $0.id, chat: $0.chat, createdAt: $0.createdAt.toDate, from: $0.from, to: $0.to) }
        return payload
    }
    
    private func scrollToLast() {
        let count = collectionView.numberOfItems(inSection: 0)
        collectionView.scrollToItem(at: IndexPath(item: count - 1, section: 0), at: .bottom, animated: true)
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
