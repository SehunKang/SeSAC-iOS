//
//  StretchyTableHeaderView.swift
//  Json_Prac
//
//  Created by Sehun Kang on 2021/12/20.
//

import UIKit
import SnapKit

class StretchyTableHeaderView: UIView {
    var imageViewHeight = NSLayoutConstraint()
    var imageViewBottom = NSLayoutConstraint()
    
    var containerView: UIView!
    var imageView: UIImageView!
    
    var containerViewHeight = NSLayoutConstraint()
    
    let discriptionView = MainDiscriptionView()
    var discriptionViewHeight = NSLayoutConstraint()
    var discriptionViewBottom = NSLayoutConstraint()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
        
        setViewConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createViews() {
        // Container View
        containerView = UIView()
        self.addSubview(containerView)
        
        // ImageView for background
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(discriptionView)
        containerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        // UIView Constraints
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        // Container View Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        discriptionView.translatesAutoresizingMaskIntoConstraints = false
//        discriptionViewBottom = discriptionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        discriptionViewHeight = discriptionView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5)
        discriptionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).inset(20)
            make.height.equalTo(300)
        }
        discriptionView.layer.zPosition = 10
        
        // ImageView Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.snp.makeConstraints { make in
//            make.bottom.equalTo(discriptionView.snp.top).offset(-40)
//            make.width.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.5)
//        }
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: discriptionView.topAnchor, constant: 50)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        print(offsetY)
        print(scrollView.contentInset.top)
//        containerView.clipsToBounds = offsetY <= 0
//        imageViewBottom.constant = offsetY >= 47 ? 50 : 47 - (offsetY / 2)
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
//        imageView.snp.makeConstraints { make in
//            make.height.equalTo(max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top))
//            make.bottom.equalTo(offsetY >= 0 ? 0 : -offsetY / 2)
//        }
    }
}
