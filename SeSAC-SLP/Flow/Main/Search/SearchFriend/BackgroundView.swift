//
//  AroundBackgroundView.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/08.
//

import UIKit

class BackgroundView: UIView {
    
    static let identifier = "BackgroundView"
   
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonRefresh: OutlineButton!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var buttonChangeHobby: FilledButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
        configUI()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: BackgroundView.identifier, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

    
    private func configUI() {
        buttonChangeHobby.setTitleWithFont(text: "취미 변경하기", font: CustomFont.Body3_R14)
        labelMainTitle.font = CustomFont.Display1_R20.font
        labelSubTitle.font = CustomFont.Title4_R14.font
    }
}
