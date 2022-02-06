//
//  SearchHobbyViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchHobbyViewController: UIViewController {
    
    static let identifier = "SearchHobbyViewController"
    
    let disposeBag = DisposeBag()

    enum Section: Int, Hashable, CaseIterable {
        case around, mine
        
        var description: String {
            switch self {
            case .around: return "Around"
            case .mine: return "Mine"
            }
        }
    }
    static let headerElement = "Header-Element"
    
    struct Item: Hashable {
        let hobbyAround: hobbyAroundItem?
        let hobbyMine: String?
        init(hobbyAround: hobbyAroundItem? = nil, hobbyMine: String? = nil) {
            self.hobbyAround = hobbyAround
            self.hobbyMine = hobbyMine
        }
        private let identifier = UUID()
    }
    
    struct hobbyAroundItem: Hashable {
        let hobby: String?
        let isServiceRecommended: Bool?
        init(hobby: String? = nil, isServiceRecommended: Bool? = nil) {
            self.hobby = hobby
            self.isServiceRecommended = isServiceRecommended
        }
        private let identifier = UUID()
    }
    
    var data = UserDefaultManager.queueData
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var aroundSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
    var hobbySnapshot = NSDiffableDataSourceSectionSnapshot<Item>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBackButtonConfigure()
        UIConfigure()
        collectionViewConfigure()
    }
    
    private func UIConfigure() {
        let searchBar = UISearchBar(frame: .infinite)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.delegate = self
        searchBar.rx.textDidEndEditing
            .subscribe { _ in
                print("end?!?!?!?!!?!?")
            }
            .disposed(by: disposeBag)

    }
    
    private func collectionViewConfigure() {
        configureHierarchy()
        configureDataSource()
        snapShotInit()
    }
    

}

extension SearchHobbyViewController {
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let section: NSCollectionLayoutSection
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(38))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SearchHobbyViewController.headerElement, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createAroundCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, hobbyAroundItem> {
        return UICollectionView.CellRegistration<UICollectionViewCell, hobbyAroundItem> { cell, indexPath, item in
            
            var content = UIListContentConfiguration.cell()
            content.text = item.hobby
            content.textProperties.font = CustomFont.Title4_R14.font
            
            //            content.textProperties.alignment = .center 이거 하면 런타임에러..
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeWidth = 1.0
            if item.isServiceRecommended! {
                background.strokeColor = CustomColor.SLPError.color
                content.textProperties.color = CustomColor.SLPError.color
            } else {
                background.strokeColor = CustomColor.SLPGray4.color
            }
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = background
        }
    }
    
    func createMineCellRegistration() -> UICollectionView.CellRegistration<MyHobbyCell, String> {
        return UICollectionView.CellRegistration<MyHobbyCell, String> { cell, indexPath, item in
            
            cell.label.text = item
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = CustomColor.SLPGreen.color.cgColor
            cell.layer.borderWidth = 1.0
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: SearchHobbyViewController.headerElement) { supplementaryView, elementKind, indexPath in
            
            var content = supplementaryView.defaultContentConfiguration()
        
            if indexPath.section == 0 {
                content.text = "지금 주변에는"
            } else {
                content.text = "내가 하고 싶은"
            }
            content.textProperties.font = CustomFont.Title6_R12.font
            
            supplementaryView.contentConfiguration = content
        }
    }
    
    func configureDataSource() {
        
        let aroundCellRegistration = createAroundCellRegistration()
        let mineCellRegistration = createMineCellRegistration()
        let headerRegistration = createHeaderRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("unknown section")}
            switch section {
            case .around:
                return collectionView.dequeueConfiguredReusableCell(using: aroundCellRegistration, for: indexPath, item: itemIdentifier.hobbyAround)
            case .mine:
                return collectionView.dequeueConfiguredReusableCell(using: mineCellRegistration, for: indexPath, item: itemIdentifier.hobbyMine)
            }
        })
        
        dataSource.supplementaryViewProvider = {collectionView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func snapShotInit() {
        
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        guard let data = data else {return}
        let recommendedItem = data.fromRecommend.map {Item(hobbyAround: hobbyAroundItem(hobby: $0, isServiceRecommended: true))}
        aroundSnapshot.append(recommendedItem)
        
        let memberArray = data.fromQueueDB.map { $0.hf }
        let memberHobbyItem = memberArray.flatMap{$0}.map { Item(hobbyAround: hobbyAroundItem(hobby: $0, isServiceRecommended: false)) }
        aroundSnapshot.append(memberHobbyItem)
        
        let hobbyArray = data.fromRecommend.map {Item(hobbyMine: $0) }
        hobbySnapshot.append(hobbyArray)
        
        dataSource.apply(hobbySnapshot, to: .mine)
        dataSource.apply(aroundSnapshot, to: .around)
    }
    
    func addItemToMineHobbySection(text: String) {
        
        let item = Item(hobbyMine: text)
        hobbySnapshot.append([item])
        dataSource.apply(hobbySnapshot, to: .mine)
    }

    
}

extension SearchHobbyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        guard let data = data else {
            print("no data")
            return
        }
        
        let recommended = data.fromRecommend
        let fromUser = data.fromQueueDB.map{$0.hf}.flatMap{$0}
        let dataArray = recommended + fromUser
        
        if indexPath.section == Section.around.rawValue {
            addItemToMineHobbySection(text: dataArray[indexPath.item])
        } else {
            let itemToDelete = hobbySnapshot.items[indexPath.item]
            hobbySnapshot.delete([itemToDelete])
            dataSource.apply(hobbySnapshot, to: .mine)
        }
        
    }
}

extension SearchHobbyViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("end editing**************************************")
        guard let text = searchBar.text else {return}
        //나중에 text validation으로 한번에
        if text == "" {return}
        addItemToMineHobbySection(text: text)
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("end editing**************************************")
//        guard let text = searchBar.text else {return}
//        //나중에 text validation으로 한번에
//        if text == "" {return}
//
//        let item = Item(hobbyMine: text)
//        var mineSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
//        mineSnapshot.append([item])
//        dataSource.apply(mineSnapshot, to: .mine)
//
//    }
    
}
