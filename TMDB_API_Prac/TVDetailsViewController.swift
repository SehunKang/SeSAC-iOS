//
//  TVDetailsViewController.swift
//  TMDB_API_Prac
//
//  Created by Sehun Kang on 2021/12/26.
//

import Foundation
import UIKit
import SnapKit

class TVDetailsViewController: UIViewController {
    
    var data: TvShowDetail!
    
    static let identifier = "TVDetailsViewController"
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(TVDetailsTableViewCell.self, forCellReuseIdentifier: TVDetailsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}

extension TVDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.numberOfSeasons
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TVDetailsTableViewCell.identifier, for: indexPath) as? TVDetailsTableViewCell else { return UITableViewCell() }
        
        let season = data.seasons[indexPath.row + 1]
        
        APIService().requestPoster(posterPath: season.posterPath) { image in
            DispatchQueue.main.async {
                cell.image.image = image
            }
        }
        cell.titleLabel.text = "\(data.name) \(season.name)"
        cell.infoLabel.text = "\(season.airDate!) | Episode \(season.episodeCount)"
        cell.detailLabel.text = season.overview
        
        return cell
    }
    
    
    
}
