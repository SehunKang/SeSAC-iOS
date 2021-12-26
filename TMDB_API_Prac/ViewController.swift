//
//  ViewController.swift
//  TMDB_API_Prac
//
//  Created by Sehun Kang on 2021/12/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var TVShowData: TVshow?
    
    var searchText: String? {
        didSet {
            APIService().requestSearch(searchQuery: searchText!) { data in
                
                DispatchQueue.main.async {
                    self.TVShowData = data
                    self.collectionView.reloadData()
                    
                }
            }
            currentPage = 1
        }
    }
    
    var currentPage: Int!
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavBar()
        setCollectionView()
    }
    
    func setNavBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    func setCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }

}

//MARK: CollectionViewDelegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let result = TVShowData?.totalResults ?? 0
        print(result)
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 10) / 3
        let height: CGFloat = width * 1.41
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { return UICollectionViewCell()}


        if self.searchText == nil {return UICollectionViewCell()}
        
        if indexPath.item > (currentPage * 20 - 1) {
            currentPage = indexPath.item / 20 + 1
            APIService().requestSearch(searchQuery: self.searchText!, page: currentPage) { data in
                self.TVShowData = data
            }
        } else if indexPath.item < ((currentPage - 1) * 20) {
            currentPage = indexPath.item / 20 + 1
            DispatchQueue.main.async {
                APIService().requestSearch(searchQuery: self.searchText!, page: self.currentPage) { data in
                    self.TVShowData = data
                }
            }
        }
        
        if let posterPath = self.TVShowData?.results[indexPath.item - ((currentPage - 1) * 20)].posterPath {
            APIService().requestPoster(posterPath: posterPath) { image in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        } else {
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(systemName: "x.circle")
            }
        }
        return cell
    }
        
}

//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        self.searchText = text
    }
    
    
}

class ImageCell: UICollectionViewCell {
    
    static let identifier = "ImageCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class HeaderView: UICollectionReusableView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "영화 및 TV 프로그램"
        label.font = .boldSystemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
