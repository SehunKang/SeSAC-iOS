//
//  MyCell.swift
//  CollectionViewPrac
//
//  Created by Sehun Kang on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class MyCell: UIViewController {
    
    static let reuseIdentifier = "My-Cell"
    
    enum SectionLayoutKind: Int, Hashable, CaseIterable, CustomStringConvertible {
        case title, hobby, review
        
        var description: String {
            switch self {
            case .title:
                return "Title"
            case .hobby:
                return "Hobby"
            case .review:
                return "Review"
            }
        }
    }
    
    static let sectionheaderElementKind = "section-header-element-kind"
    
    struct Item: Hashable {
        let reputation: Int?
        let hobby: String?
        let comment: String?
        var isEmptyComment: Bool?
        init(reputation: Int? = nil, hobby: String? = nil, comment: String? = nil, isEmptyComment: Bool? = nil) {
            self.reputation = reputation
            self.hobby = hobby
            self.comment = comment
            self.isEmptyComment = isEmptyComment
        }
        private let identifier = UUID()
    }
    
    var data = UserData(hobby: ["hobby one", "hobby two", "hobby three", "hobby fourfour"],comment: nil, reputation: [1,0,1,0,1,0])
        
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Item>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshots()
        
    }
    @objc func touchHeader() {
        print("touch!")
    }
}

extension MyCell {
    
    func createLayout() -> UICollectionViewLayout {
     
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = SectionLayoutKind(rawValue: sectionIndex) else {return nil}
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .title {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(34))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(8)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

            } else if sectionKind == .hobby {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(34))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
                section.interGroupSpacing = 8
            } else if sectionKind == .review {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            } else {
                fatalError("Unknown section")
            }
            let headerSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSIze, elementKind: MyCell.sectionheaderElementKind, alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

extension MyCell {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func createTitleCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, indexPath, item in
            var content = UIListContentConfiguration.cell()
            content.text = "item is \(item)"
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            background.strokeWidth = 1.0
            cell.backgroundConfiguration = background
        }
    }
    
    func createHobbyCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewCell, String> { cell, indexPath, item in
            var content = UIListContentConfiguration.cell()
            content.text = item
//            content.textProperties.alignment = .center 이렇게 하면 오류 생김
            cell.contentConfiguration = content
            cell.sizeToFit()
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGreen
            background.strokeWidth = 1.0
            cell.backgroundConfiguration = background
        }
    }
    
    func createReviewCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
            var content = UIListContentConfiguration.cell()
            if item.comment != nil {
                content.text = item.comment
            } else {
                content.attributedText = NSAttributedString(string: "첫 리뷰를 기다리는 중이에요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor])
            }
            content.textProperties.numberOfLines = 0
            cell.contentConfiguration = content
            
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: MyCell.sectionheaderElementKind) { supplementaryView, elementKind, indexPath in
            var content = supplementaryView.defaultContentConfiguration()
            content.text = "Header at \(indexPath.section)"
            supplementaryView.contentConfiguration = content
            if indexPath.section == 2 {
                supplementaryView.accessories = [.disclosureIndicator()]
            }
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touchHeader))
            supplementaryView.contentView.addGestureRecognizer(gesture)
        }
    }
    
    func configureDataSource() {
        
        let titleCellRegistration = createTitleCellRegistration()
        let hobbyCellRegistration = createHobbyCellRegistration()
        let reviewCellRegistration = createReviewCellRegistration()
        let headerRegistration = createHeaderRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Item>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            
            guard let section = SectionLayoutKind(rawValue: indexPath.section) else {fatalError("unknown Section")}
            switch section {
            case .title:
                return collectionView.dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: itemIdentifier.reputation)
            case .hobby:
                return collectionView.dequeueConfiguredReusableCell(using: hobbyCellRegistration, for: indexPath, item: itemIdentifier.hobby)
            case .review:
                return collectionView.dequeueConfiguredReusableCell(using: reviewCellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    
    func applyInitialSnapshots() {
     
        let sections = SectionLayoutKind.allCases
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        let titleItems = data.reputation.map { Item(reputation: $0)}
        var titleSS = NSDiffableDataSourceSectionSnapshot<Item>()
        titleSS.append(titleItems)
        
        let hobbyItems = data.hobby.map { Item(hobby: $0)}
        var hobbySS = NSDiffableDataSourceSectionSnapshot<Item>()
        hobbySS.append(hobbyItems)
        
        let commentItems = Item()
        var commentSS = NSDiffableDataSourceSectionSnapshot<Item>()
        commentSS.append([commentItems])
        
        dataSource.apply(titleSS, to: .title)
        dataSource.apply(hobbySS, to: .hobby)
        dataSource.apply(commentSS, to: .review)
        
    }
        
}


extension MyCell: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
