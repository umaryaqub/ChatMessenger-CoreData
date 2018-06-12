//
//  MessageCell.swift
//  ChatMessenger
//
//  Created by Umar Yaqub on 01/05/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0/255, green: 134/255, blue: 249/255, alpha: 1) : UIColor.clear
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.lightGray
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var message: Message? {
        didSet {
            let username = message?.friend?.name ?? ""
            let text = message?.text ?? ""
            let profileImageName = message?.friend?.profileImageName ?? ""
            nameLabel.text = username
            messageLabel.text = text
            userProfileIV.image = UIImage(named: profileImageName)
            messageReadIV.image = UIImage(named: profileImageName)
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                // if messeage sent ago was more than a week ago then show the date
                let elapsedTimeInSeconds = NSDate().timeIntervalSince(date as Date)
                let secondInDays: TimeInterval = 60 * 60 * 24
                if elapsedTimeInSeconds > 7 * secondInDays {
                    dateFormatter.dateFormat = "dd/MM/yy"
                    // if messeage sent ago was only greater than 24 hours display the day instead
                } else if elapsedTimeInSeconds > secondInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    
    let userProfileIV: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 70/2
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let messageReadIV: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20/2
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfileIVAndBorder()
        setupContainerWithImageViewAndLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProfileIVAndBorder() {
        addSubview(userProfileIV)
        addSubview(borderLine)
        
        userProfileIV.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userProfileIV.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userProfileIV.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        userProfileIV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        borderLine.leftAnchor.constraint(equalTo: userProfileIV.rightAnchor, constant: 0).isActive = true
        borderLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        borderLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        borderLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    private func setupContainerWithImageViewAndLabels() {
        addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(messageReadIV)
        
        containerView.heightAnchor.constraint(equalTo: userProfileIV.heightAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: userProfileIV.rightAnchor, constant: 5).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: userProfileIV.topAnchor, constant: 7).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: userProfileIV.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: messageReadIV.leftAnchor, constant: -10).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        messageReadIV.rightAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        messageReadIV.widthAnchor.constraint(equalToConstant: 20).isActive = true
        messageReadIV.heightAnchor.constraint(equalToConstant: 20).isActive = true
        messageReadIV.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor).isActive = true
        
    }
}
