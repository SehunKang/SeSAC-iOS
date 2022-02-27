//
//  MyChatCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/13.
//

import UIKit
import SnapKit

class ChatCellSend: UICollectionViewCell {
    
    static let reuseIdentifier = "ChatCellSend"
    
    enum ChatType: CaseIterable {
        case receive
        case send
    }
    
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
            messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: messageTextView.leadingAnchor, constant: -8)
        ])
        messageTextView.backgroundColor = CustomColor.SLPWhitegreen.color

    }
    
}
