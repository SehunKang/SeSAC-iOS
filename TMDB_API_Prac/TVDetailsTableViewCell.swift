//
//  TVDetailsTableViewCell.swift
//  TMDB_API_Prac
//
//  Created by Sehun Kang on 2021/12/26.
//

import Foundation
import UIKit
import SnapKit

class TVDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "TVDetailsTableViewCell"
    
    let image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayOut()
    }
    
    func setLayOut() {
        [image, titleLabel, infoLabel, detailLabel].forEach {
            self.addSubview($0)
        }
       
        image.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image)
            make.leading.equalTo(image.snp.trailing).offset(5)
            make.height.equalTo(30)
            make.trailing.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(20)
            make.trailing.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
