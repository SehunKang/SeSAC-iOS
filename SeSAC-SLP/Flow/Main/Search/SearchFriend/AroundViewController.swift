//
//  AroundViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/08.
//

import UIKit
import SnapKit
import Tabman

class AroundViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.labelMainTitle.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        view.labelSubTitle.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        return view
    }()
    
    //완료 하고 FromQueueDB hashable 바꿔줄까?
    var dataSource: UICollectionViewDiffableDataSource<Section, FromQueueDB>! = nil
    
    let data = [FromQueueDB(uid: "aabc", nick: "nick", lat: 10, long: 10, reputation: [0,0,0,0,0,0,0,0], hf: ["hobby1", "hobby2", "hobby3", "hobby4", "hobby5", "hobby6"], reviews: ["good", "very good"], gender: 0, type: 0, sesac: 0, background: 0), FromQueueDB(uid: "aabcds", nick: "nick", lat: 10, long: 10, reputation: [0,0,0,0,0,0,0,0], hf: ["hobby1", "hobby2", "hobby3", "hobby4", "hobby5", "hobby6"], reviews: ["goodasdklfnk\nasdklfnmalksdnf\nalmsnkdfnalksd\nanklsdfnlaksdfn\nalkdnsflkasndflkdsa\nalnskdfnalskdfnaslkdfnskla", "very good"], gender: 0, type: 0, sesac: 0, background: 0)]
//    let data: [FromQueueDB] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }
    

}

extension AroundViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(252))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
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
    
    func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, FromQueueDB>(collectionView: collectionView){ (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
                fatalError()
            }
            cell.data = itemIdentifier
            return cell
        }
        collectionView.dataSource = dataSource

        var snapshot = NSDiffableDataSourceSnapshot<Section, FromQueueDB>()
        
        if snapshot.numberOfSections == 0 {
            snapshot.appendSections([.main])
            snapshot.appendItems(data)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension AroundViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
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
