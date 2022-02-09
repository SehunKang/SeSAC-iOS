//
//  RequestReceivedViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/08.
//

import UIKit
import SnapKit

class RequestReceivedViewController: UIViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.labelMainTitle.text = "아직 받은 요청이 없어요ㅠ"
        view.labelSubTitle.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

}

extension RequestReceivedViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(252))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    
}


extension RequestReceivedViewController {
    
    private func configureHierarchy() {
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(34)
        }
        collectionView.layoutIfNeeded()

        collectionView.backgroundView = backgroundView
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
}
