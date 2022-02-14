//
//  CollectionViewCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/09.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.font = CustomFont.Title1_M16.font
        label.sizeToFit()
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let sesacImageView = UIImageView()
    
    let container = UIView()
    
    
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private lazy var rootStack: UIStackView = {
        let rootStack = UIStackView(arrangedSubviews: [nameLabel, disclosureIndicator])
        rootStack.alignment = .center
        rootStack.distribution = .fillProportionally
        rootStack.spacing = 40
        rootStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        rootStack.isLayoutMarginsRelativeArrangement = true
        return rootStack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rootStack, collectionView])
        stack.axis = .vertical
        stack.spacing = padding
        return stack
    }()
    
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?

    private let padding: CGFloat = 8
    
    enum SectionLayoutKind: Int, Hashable, CaseIterable, CustomStringConvertible, Equatable {
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
    
    static let sectionHeaderElement = "section-header-element"
    
    var mainSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Item>()
    
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

    var data: FromQueueDB? {
        didSet {
            nameInit()
//            collectionView.heightAnchor.constraint(equalToConstant: collectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
//            collectionView.heightAnchor.constraint(equalToConstant: 472).isActive = true
//            collectionView.layoutIfNeeded()

        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Item>! = nil
    
  
//    when collectionviewcell
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setUp()
    }
    
    private func setUp() {

        clipsToBounds = true
        layer.cornerRadius = 8
        
        
        setUpConstraints()
        configureDataSource()
        collectionView.delegate = self
    }
    
    private func setUpConstraints() {
//        contentView.addSubview(mainStack)
        contentView.addSubview(imageView)
        contentView.addSubview(container)
        imageView.addSubview(sesacImageView)
        container.addSubview(mainStack)

        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        sesacImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 194),
            imageView.bottomAnchor.constraint(equalTo: mainStack.topAnchor),
            
//            mainStack.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            container.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            container.topAnchor.constraint(equalTo: mainStack.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 287),
            
            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            //contentsize로 하면 처음엔 컨텐츠보다 height이 더 길다. 일단 제일 적절한 472로 고정
            collectionView.heightAnchor.constraint(equalToConstant: 472),
            
            sesacImageView.widthAnchor.constraint(equalToConstant: 184),
            sesacImageView.heightAnchor.constraint(equalToConstant: 184),
            sesacImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            sesacImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
                                                                    
        
        closedConstraint = nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        closedConstraint?.priority = .defaultLow
        closedConstraint?.isActive = true
        openConstraint = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        openConstraint?.priority = .defaultLow
        
        container.layer.borderWidth = 1
        container.layer.borderColor = CustomColor.SLPGray2.color.cgColor
        container.layer.cornerRadius = 8
        
    }
    
    private func updateAppearance() {

        closedConstraint?.isActive = !isSelected
        openConstraint?.isActive = isSelected
        
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999)
            self.disclosureIndicator.transform = self.isSelected ? upsideDown : .identity
        }
        
    }
}

extension CardCell {
    
    private func createLayout() -> UICollectionViewLayout {

        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = SectionLayoutKind(rawValue: sectionIndex) else {return nil}
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .title {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(38))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(8)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

            } else if sectionKind == .hobby {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(38))
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
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSIze, elementKind: CardCell.sectionHeaderElement, alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func createTitleCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, indexPath, item in

            var content = UIListContentConfiguration.cell()
            content.text = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"][indexPath.item]
            content.textProperties.alignment = .center
            content.textProperties.font = CustomFont.Title4_R14.font
            content.directionalLayoutMargins = .zero
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeWidth = 1.0
            background.backgroundColor = item > 0 ? CustomColor.SLPGreen.color : .clear
            background.strokeColor = item > 0 ? CustomColor.SLPGreen.color : .systemGray3
            content.textProperties.color = item > 0 ? CustomColor.SLPWhite.color : CustomColor.SLPBlack.color
            cell.contentConfiguration = content
            cell.backgroundConfiguration = background
        }
    }
    
    func createHobbyCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewCell, String> { cell, indexPath, item in

            var content = UIListContentConfiguration.cell()
            content.text = item
//            content.textProperties.alignment = .center 이렇게 하면 오류 생김
            content.textProperties.font = CustomFont.Title4_R14.font
            content.textProperties.allowsDefaultTighteningForTruncation = true
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = CustomColor.SLPGray2.color
            background.strokeWidth = 1.0
            cell.backgroundConfiguration = background
            cell.contentConfiguration = content
        }
    }
    
    func createReviewCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in

            var content = UIListContentConfiguration.cell()
            if self.data?.reviews.count != 0 {
                content.text = item.comment
            } else {
                //attributedText로 했다가 에러나서 디버깅으로 두시간 날려먹음
//                content.attributedText = NSAttributedString(string: "첫 리뷰를 기다리는 중이에요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor])
                content.textProperties.color = CustomColor.SLPGray2.color
                content.text = "첫 리뷰를 기다리는 중이에요!"
            }
            content.textProperties.numberOfLines = 2
            content.textProperties.font = CustomFont.Body3_R14.font
            cell.contentConfiguration = content
            
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: CardCell.sectionHeaderElement) { supplementaryView, elementKind, indexPath in

            var content = supplementaryView.defaultContentConfiguration()
            let headerText: String
            switch indexPath.section {
            case SectionLayoutKind.title.rawValue: headerText = "새싹 타이틀"
            case SectionLayoutKind.hobby.rawValue: headerText = "하고 싶은 취미"
            case SectionLayoutKind.review.rawValue: headerText = "새싹 리뷰"
            default:
                return
            }
            content.text = headerText
            content.textProperties.font = CustomFont.Title6_R12.font
            supplementaryView.contentConfiguration = content
            
            let commentCount = self.data?.reviews.count ?? 0
            if (indexPath.section == SectionLayoutKind.review.rawValue) && (commentCount >= 2) {
                supplementaryView.accessories = [.disclosureIndicator()]
            }
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
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func nameInit() {

        guard let data = data else {
            print("nil data")
            return
        }
        nameLabel.text = data.nick
        
        if mainSnapshot.numberOfSections == 0 {
            
            mainSnapshot.appendSections(SectionLayoutKind.allCases)
            dataSource.apply(mainSnapshot)
            
            let titleItems = data.reputation.map { Item(reputation: $0)}
            var titleSS = NSDiffableDataSourceSectionSnapshot<Item>()
            titleSS.append(Array(titleItems[0...5]))
            
            let hobbyItems = data.hf.map { Item(hobby: $0)}
            var hobbySS = NSDiffableDataSourceSectionSnapshot<Item>()
            hobbySS.append(hobbyItems)
            
            let commentItems = Item(comment: data.reviews.first)
            var commentSS = NSDiffableDataSourceSectionSnapshot<Item>()
            commentSS.append([commentItems])
            
            dataSource.apply(titleSS, to: .title)
            dataSource.apply(hobbySS, to: .hobby)
            dataSource.apply(commentSS, to: .review)
        }

    }
}

extension CardCell: UICollectionViewDelegate {
    
    
    // header 클릭은 delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

