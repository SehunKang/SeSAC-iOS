//
//  BookTableViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/20.
//

import UIKit

class BookTableViewController: UIViewController {

	var list: [TvShow]?
	@IBOutlet weak var bookCollectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		bookCollectionView.delegate = self
		bookCollectionView.dataSource = self
		
		let nibName = UINib(nibName: CollectionViewCell.identifier, bundle: nil)
		bookCollectionView.register(nibName, forCellWithReuseIdentifier: CollectionViewCell.identifier)
		
		let layout = UICollectionViewFlowLayout()
		let spacing = 10.0
		let width = (UIScreen.main.bounds.width / 2) - (spacing * 4)
		layout.itemSize = CGSize(width: width, height: width)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumInteritemSpacing = spacing
		layout.minimumLineSpacing = spacing
		layout.scrollDirection = .vertical
		bookCollectionView.collectionViewLayout = layout

    }
    

}

extension BookTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return list!.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier , for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
		cell.title.text = list![indexPath.item].title
		cell.image.image = UIImage(named: list![indexPath.item].title)
		cell.rate.text = String(list![indexPath.item].rate)
		cell.bookView.backgroundColor = UIColor.orange
		return cell
		
	}
	
	
	
}
