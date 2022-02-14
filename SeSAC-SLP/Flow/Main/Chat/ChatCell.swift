//
//  MyChatCell.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/13.
//

import UIKit
import SnapKit

class ChatCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ChatCell"
    
    enum ChatType: CaseIterable {
        case receive
        case send
    }
    
    struct Model {
        let message: String
        let chatType: ChatType
        let date: String
    }
    
    var model: Model? {
        didSet {
            bind()
        }
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
            messageTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func bind() {
        guard let model = model, let font = messageTextView.font else {
            return
        }
        messageTextView.text = model.message
        timeLabel.text = model.date
        let estimatedFrame = model.message.getEstimatedFrame(with: font)
        
        messageTextView.widthAnchor.constraint(equalToConstant: estimatedFrame.width + 16).isActive = true
        
        if model.chatType == .receive {
            messageTextView.backgroundColor = .clear
            messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            messageTextView.layer.borderColor = CustomColor.SLPGray4.color.cgColor
            messageTextView.layer.borderWidth = 1
            timeLabel.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 8).isActive = true
        } else {
            messageTextView.backgroundColor = CustomColor.SLPWhitegreen.color
            messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            timeLabel.trailingAnchor.constraint(equalTo: messageTextView.leadingAnchor, constant: -8).isActive = true
        }
    }
    
}


extension String {
    func getEstimatedFrame(with font: UIFont) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width * 2/3, height: 1000)
        let optionss = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: optionss, attributes: [.font: font], context: nil)
        return estimatedFrame
    }
}
