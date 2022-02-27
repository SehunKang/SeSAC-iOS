//
//  UIView+Extension.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/04.
//

import Foundation
import UIKit

extension UIView {
    
    func shadowConfig() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
    
    func addOverlay(yPosition: CGFloat = 0, tapGesture: UIGestureRecognizer) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = CGRect(x: 0, y: yPosition, width: self.bounds.width, height: self.bounds.height)
        overlay.layer.zPosition = 2
        overlay.backgroundColor = .black.withAlphaComponent(0.5)
        overlay.tag = 100
        overlay.addGestureRecognizer(tapGesture)
        addSubview(overlay)
        
        
    }
    
    func removeOverlay() {
        guard let overlay = self.subviews.filter({ view in
            view.tag == 100
        }).first else {return}
        overlay.removeFromSuperview()
    }
}
