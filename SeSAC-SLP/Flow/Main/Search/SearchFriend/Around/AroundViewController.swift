//
//  AroundViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/08.
//

import UIKit
import SnapKit

class AroundViewController: UIViewController {
    
    lazy var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100), collectionViewLayout: createLayout())

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureHierarchy()
        
        
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
        
        view.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
//        let backgroundView = BackgroundView()
        collectionView.backgroundView = BackgroundView()
    }
}
