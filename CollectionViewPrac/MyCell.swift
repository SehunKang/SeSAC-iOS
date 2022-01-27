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
        case name, title, hobby, review
        
        var description: String {
            switch self {
            case .name:
                return "Name"
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
        let name: String?
        let reputation: Int?
        let hobby: String?
        let comment: String?
        var isEmptyComment: Bool?
        init(name: String? = nil, reputation: Int? = nil, hobby: String? = nil, comment: String? = nil, isEmptyComment: Bool? = nil) {
            self.name = name
            self.reputation = reputation
            self.hobby = hobby
            self.comment = comment
            self.isEmptyComment = isEmptyComment
        }
        private let identifier = UUID()
    }
    
    var data = UserData(name: "고래밥", hobby: ["hobby one", "hobby two", "hobby three", "hobby fourfour"],comment: ["hi", "ho"], reputation: [1,0,1,0,1,0])
        
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Item>! = nil
    var collectionView: UICollectionView! = nil
    
    var closed = false {
        didSet {
            if closed == true {
                self.openSections()
            } else {
                self.closeSections()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        closeSections()
//        openSections()
        
    }
    @objc func touchHeader() {
        print("touch!")
    }
    
    @objc func nameClicked() {
        closed = !closed
    }
}

extension MyCell {
    
    func createLayout() -> UICollectionViewLayout {
     
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = SectionLayoutKind(rawValue: sectionIndex) else {return nil}
            
            let section: NSCollectionLayoutSection
            if sectionKind == .name{
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(58))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
                
            } else if sectionKind == .title {
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
            if sectionIndex != 0 {
                section.boundarySupplementaryItems = [header]
            }
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
    
    func createNameCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, item in
            var content = UIListContentConfiguration.cell()
            content.text = item
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
            cell.contentView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.nameClicked))
            cell.contentView.addGestureRecognizer(gesture)
        }
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
            
            let commentCount = self.data.comment?.count ?? 0
            if indexPath.section == SectionLayoutKind.review.rawValue && commentCount >= 2 {
                supplementaryView.accessories = [.disclosureIndicator()]
            }
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touchHeader))
            supplementaryView.contentView.addGestureRecognizer(gesture)
        }
    }
    
    
    func configureDataSource() {
        
        let nameCellRegistration = createNameCellRegistration()
        let titleCellRegistration = createTitleCellRegistration()
        let hobbyCellRegistration = createHobbyCellRegistration()
        let reviewCellRegistration = createReviewCellRegistration()
        let headerRegistration = createHeaderRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Item>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            
            guard let section = SectionLayoutKind(rawValue: indexPath.section) else {fatalError("unknown Section")}
            switch section {
            case .name:
                return collectionView.dequeueConfiguredReusableCell(using: nameCellRegistration, for: indexPath, item: itemIdentifier.name)
            case .title:
                return collectionView.dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: itemIdentifier.reputation)
            case .hobby:
                return collectionView.dequeueConfiguredReusableCell(using: hobbyCellRegistration, for: indexPath, item: itemIdentifier.hobby)
            case .review:
                return collectionView.dequeueConfiguredReusableCell(using: reviewCellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    
    func openSections() {
     
        let sections = SectionLayoutKind.allCases
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        let nameItem = Item(name: data.name)
        var nameSS = NSDiffableDataSourceSectionSnapshot<Item>()
        nameSS.append([nameItem])
        
        let titleItems = data.reputation.map { Item(reputation: $0)}
        var titleSS = NSDiffableDataSourceSectionSnapshot<Item>()
        titleSS.append(titleItems)
        
        let hobbyItems = data.hobby.map { Item(hobby: $0)}
        var hobbySS = NSDiffableDataSourceSectionSnapshot<Item>()
        hobbySS.append(hobbyItems)
        
        let commentItems = Item(comment: data.comment?.first)
        var commentSS = NSDiffableDataSourceSectionSnapshot<Item>()
        commentSS.append([commentItems])
        
        dataSource.apply(nameSS, to: .name)
        dataSource.apply(titleSS, to: .title)
        dataSource.apply(hobbySS, to: .hobby)
        dataSource.apply(commentSS, to: .review)
        let headers = collectionView.visibleSupplementaryViews(ofKind: MyCell.sectionheaderElementKind)
        headers.forEach {$0.isHidden = false}

    }
    
    func closeSections() {
        let sections = SectionLayoutKind.allCases
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: true)

        let nameItem = Item(name: data.name)
        var nameSS = NSDiffableDataSourceSectionSnapshot<Item>()
        nameSS.append([nameItem])
        dataSource.apply(nameSS, to: .name)
        let headers = collectionView.visibleSupplementaryViews(ofKind: MyCell.sectionheaderElementKind)
        headers.forEach {$0.isHidden = true}

    }
        
}


extension MyCell: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
