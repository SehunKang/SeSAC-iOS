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

class ChatViewController: UIViewController {
    
    static let identifer = "ChatViewController"

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
    
    var data: [ChatItem] = [ChatItem(message: "hi", date: "15:02", chatType: .receive), ChatItem(message: "hello", date: "16:03", chatType: .send), ChatItem(message: "asdkfnakjsdfbnakjsdbflakjsdbflakjsdbflakjsbdflkjasbdflkjasbdlfkjasbdlfkjbalsjkdfbalksdjfbalksjdbflakjsdbflkadsjbflakjsdbflakjsdbflaksjdbflkasjdbfalksjdfbalksjdfbalsjkdfbalksdjfbklj", date: "16:09", chatType: .receive)]
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfigure()
        collectionViewConfigure()
        
    }
    
    private func uiConfigure() {
        
        containerView.layer.cornerRadius = 8
        textView.font = CustomFont.Body3_R14.font
        textView.delegate = self
        
    }
    
    private func collectionViewConfigure() {
        configureHierarchy()
        configureDataSource()
        snapshotSectionInit()
        snapshotItemInit()
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
        
        let chatItem: [ChatItem] = data
        chatSnapshot.append(chatItem)
        dataSource.apply(chatSnapshot, to: .main)
    }
}

extension ChatViewController: UITextViewDelegate {
    
}
