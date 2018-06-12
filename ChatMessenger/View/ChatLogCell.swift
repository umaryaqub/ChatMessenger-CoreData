//
//  ChatLogCell.swift
//  ChatMessenger
//
//  Created by Umar Yaqub on 04/05/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//

import UIKit

class ChatLogCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    let profileIV: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40/2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let messageReadIV: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20/2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    var message: Message? {
        didSet {
            textView.text = message?.text
            messageReadIV.image = UIImage(named: message?.friend?.profileImageName ?? "")
            profileIV.image = UIImage(named: message?.friend?.profileImageName ?? "")
            // cell layout
            if message?.isSender == false {
                bubbleLeftAnchor?.isActive = true
                bubbleRightAnchor?.isActive = false
                textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                textView.textColor = .black
                profileIV.alpha = 1
                messageReadIV.alpha = 1
            } else {
                bubbleLeftAnchor?.isActive = false
                bubbleRightAnchor?.isActive = true
                textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                textView.textColor = .white
                messageReadIV.alpha = 0
                profileIV.alpha = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textBubbleView)
        addSubview(textView)
        addSubview(messageReadIV)
        addSubview(profileIV)

        layoutProfileIV()
        layoutTextAndBubbleView()
    }
    
    private func layoutTextAndBubbleView() {
        textBubbleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textBubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        bubbleWidthAnchor = textBubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleRightAnchor = textBubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        bubbleRightAnchor?.isActive = false
        
        bubbleLeftAnchor = textBubbleView.leftAnchor.constraint(equalTo: profileIV.rightAnchor, constant: 5)
        bubbleLeftAnchor?.isActive = true
        
        textView.leftAnchor.constraint(equalTo: textBubbleView.leftAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: textBubbleView.rightAnchor, constant: -5).isActive = true
        textView.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 0).isActive = true
    }
    
    private func layoutProfileIV() {
        profileIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileIV.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        profileIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        messageReadIV.heightAnchor.constraint(equalToConstant: 20).isActive = true
        messageReadIV.widthAnchor.constraint(equalToConstant: 20).isActive = true
        messageReadIV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        messageReadIV.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
