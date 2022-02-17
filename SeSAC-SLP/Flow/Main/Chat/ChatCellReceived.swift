//
//  ChatCellReceived.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/17.
//

import UIKit
import SnapKit

class ChatCellReceived: UICollectionViewCell {
    
    static let reuseIdentifier = "ChatCellReceived"
    
    let messageTextView: UITextView = {
        let view = UITextView()
        view.font = CustomFont.Body3_R14.font
        view.textColor = CustomColor.SLPBlack.color
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.isEditable = false
        view.isScrollEnabled = false
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.Title6_R12.font
        label.textColor = CustomColor.SLPGray6.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("custom cell not implemented")
    }
    
    private func configure() {
        
        contentView.addSubview(messageTextView)
        contentView.addSubview(timeLabel)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageTextView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 2/3),
            messageTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 8)
        ])
        messageTextView.backgroundColor = .clear
        messageTextView.layer.borderColor = CustomColor.SLPGray4.color.cgColor
        messageTextView.layer.borderWidth = 1

    }
}
