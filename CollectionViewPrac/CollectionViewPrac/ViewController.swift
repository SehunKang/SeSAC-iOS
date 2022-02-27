//
//  ViewController.swift
//  CollectionViewPrac
//
//  Created by Sehun Kang on 2022/01/25.
//
//
import UIKit

class ViewController: UIViewController {

    enum Section {
        case main
    }
    var collectionView: UICollectionView! = nil

    var dataSource: UICollectionViewDiffableDataSource<Section, UserData>! = nil
        
    
    let data = [UserData(name: "고래밥", hobby: ["hobby one", "hobby two", "hobby three", "hobby fourfour"],comment: ["hi", "ho"], reputation: [1,0,1,0,1,0]), UserData(name: "모래밥", hobby: ["hobby one", "hobby two", "hobby three", "hobby fourfour"],comment: ["hi", "ho"], reputation: [1,0,1,0,1,0]), UserData(name: "투래밥", hobby: ["hobby one", "hobby two", "hobby three", "hobby fourfour"],comment: ["hi", "ho"], reputation: [1,0,1,0,1,0])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)

        configureHierarchy()
        configureDataSource()
    }
    

}

extension ViewController {
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
        print(#function)

    }
    
    func configureDataSource() {
        print(#function)

        let cellRegistration = UICollectionView.CellRegistration<MyCell, UserData> { (cell, indexPath, identifier) in
            cell.data = identifier
            cell.isUserInteractionEnabled = true
            cell.sizeToFit()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UserData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            print("datasource!!!******************")
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserData>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    

}
