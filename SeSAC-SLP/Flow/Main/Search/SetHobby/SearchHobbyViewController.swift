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
import CoreLocation
import Moya
import Toast


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

    @IBOutlet var buttonFind: FilledButton!
    let searchBar = UISearchBar(frame: .infinite)
    
    var currentLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navBarBackButtonConfigure()
        collectionViewConfigure()
        UIConfigure()
    }
    
    private func UIConfigure() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.delegate = self
        
        searchBar.inputAccessoryView = buttonFind
        buttonFind.layer.zPosition = 1000
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        ges.cancelsTouchesInView = false
        view.addGestureRecognizer(ges)
        
        buttonFind.rx.tap
            .subscribe { _ in
                self.requestQueue()
            }
            .disposed(by: disposeBag)

    }
    
    @objc func viewTap() {
        searchBar.resignFirstResponder()
        //신기방기.. 이래두 되나.?
        view.addSubview(buttonFind)
        buttonFind.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
    
    private func collectionViewConfigure() {
        configureHierarchy()
        configureDataSource()
        snapShotInit()
    }
        

}

extension SearchHobbyViewController {
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let section: NSCollectionLayoutSection
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(40))
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
            
//            content.textProperties.alignment = .center //이거 하면 런타임에러..
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 2, trailing: 0) // 그래서 이렇게 하드코딩해줬다. 얼추 중간임
            
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
        
        dataSource.apply(aroundSnapshot, to: .around)
    }
    
    func addItemToMineHobbySection(text: String) {
        let item = Item(hobbyMine: text)
        hobbySnapshot.append([item])
        dataSource.apply(hobbySnapshot, to: .mine)
        collectionView.layoutIfNeeded()
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
            addItemValidate(textToAdd: dataArray[indexPath.item])
        } else {
            let itemToDelete = hobbySnapshot.items[indexPath.item]
            hobbySnapshot.delete([itemToDelete])
            dataSource.apply(hobbySnapshot, to: .mine)
        }
        
    }
}

extension SearchHobbyViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        addItemValidate(textToAdd: text)
    }
    
    private func addItemValidate(textToAdd text: String) {
        
        let count = collectionView.numberOfItems(inSection: Section.mine.rawValue)

        let arr = text.components(separatedBy: " ")

        for text in arr {
            if !isHobbyCountValid() {
                view.makeToast("취미를 더 이상 추가할 수 없습니다.")
                return
            }
            if 1 > text.count || 8 < text.count  {
                view.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다.")
                return
            }
            if count > 0 {
                if isSameTextAlreadyInItem(currentrHobbyCount: count, text: text) {
                    view.makeToast("이미 등록된 취미입니다.")
                    return
                }
            }
            addItemToMineHobbySection(text: text)
        }

    }
    
    private func isHobbyCountValid() -> (Bool) {
        
        let count = collectionView.numberOfItems(inSection: Section.mine.rawValue)

        if count > 7 {
            return false
        } else {
            return true
        }
    }
    
    private func isSameTextAlreadyInItem(currentrHobbyCount count: Int, text: String) -> (Bool) {
        for i in 0...count - 1 {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: Section.mine.rawValue)) as! MyHobbyCell
            if cell.label.text == text {
                return true
            }
        }
        return false
    }
}

extension SearchHobbyViewController {

    private func requestQueue() {
        
        if collectionView.numberOfItems(inSection: Section.mine.rawValue) == 0 {
            view.makeToast("취미를 입력해 주세요!")
            return
        }
        
        let requestData = getDataForAPI()
        
        let provider = MoyaProvider<APIServiceQueue>()
        provider.request(.queue(data: requestData)) { result in
            switch result {
            case let .success(response):
                print(response.debugDescription)
                self.responseHandlerForRequestQueue(statusCode: response.statusCode)
            case let .failure(error):
                self.errorHandler(with: error.errorCode)
            }
        }
    }
    
    private func responseHandlerForRequestQueue(statusCode: Int) {
        switch statusCode {
        case 200:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: SearchFriendViewController.identifier)
            self.navigationController?.pushViewController(vc!, animated: true)
        case 201:
            view.makeToast("신고가 누적되어 이용하실 수 없습니다.")
        case 203:
            view.makeToast("약속 취소 페널치로, 1분동안 이용하실 수 없습니다.")
        case 204:
            view.makeToast("약속 취소 페널티로, 2분동안 이용하실 수 없습니다.")
        case 205:
            view.makeToast("연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다.")
        case 206:
            view.makeToast("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!", duration: 1.0, position: .center, style: ToastManager.shared.style) { _ in
                let sb = UIStoryboard(name: "MyInfo", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: MyInfoDetailViewController.identifier)
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
                
            }
        default:
            print("responsehandlerForRequestQueue spit default", statusCode)
        }
    }
    
    private func getDataForAPI() -> [String: Any] {
        
        let latitude: Double = currentLocation.latitude
        let longitude: Double = currentLocation.longitude
        let region: Int = Int((trunc((latitude + 90) * 100) * 100000) + (trunc((longitude + 180) * 100)))
        let type = 2
        let hf = getHobby()
        let requestData = ["type": type, "region": region, "long": longitude, "lat": latitude, "hf": hf] as [String : Any]
        return requestData
        
    }
    
    ///'내가 하고 싶은' 섹션의 아이템들의 텍스트를 리턴해준다
    private func getHobby() -> [String] {
        let count = collectionView.numberOfItems(inSection: Section.mine.rawValue)
        if count == 0 { return [] }
        var hobbyArray: [String] = []
        for i in 0...count - 1 {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: Section.mine.rawValue)) as! MyHobbyCell
            hobbyArray.append(cell.label.text!)
        }
        return hobbyArray

    }
}
