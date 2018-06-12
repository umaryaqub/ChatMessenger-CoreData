//
//  ChatLogController.swift
//  ChatMessenger
//
//  Created by Umar Yaqub on 04/05/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    private let cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for blockOperation in self.blockOperations {
                blockOperation.start()
            }
        }, completion: { (completed) in
            let item = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: item, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
    }
    
    @objc private func handleSend() {
        guard let text = inputTextField.text else { return }
        guard let friend = friend else { return }
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        MessagesController.createMessageWithText(text: text, friend: friend, minutesAgo: 0, context: context, isSender: true)
        do {
            try context.save()
            inputTextField.text = ""
        } catch let err {
            print(err)
        }
    }
    
    private func fetchMessages() {
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        // takes in container view height into consideration
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 52, right: 0)
        
        tabBarController?.tabBar.isHidden = true
        fetchMessages()
        setupContainerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(handleSimulate))
    }
    
    @objc func handleSimulate() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        MessagesController.createMessageWithText(text: "This is a new message...", friend: friend!, minutesAgo: 0, context: context)
        MessagesController.createMessageWithText(text: "This is an old message...", friend: friend!, minutesAgo: 0, context: context)
        do {
            try context.save()
            
        } catch let err {
            print(err)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        print("keyboard active")
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            messageInputCVBottomAnchor?.constant -= frame.height
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                let item = self.fetchedResultsController.sections![0].numberOfObjects - 1
                let indexPath = IndexPath(item: item, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        print("keyboard hidden")
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            messageInputCVBottomAnchor?.constant += frame.height
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in

            }
        }
    }
    
    var messageInputCVBottomAnchor: NSLayoutConstraint?
    
    private func setupContainerView() {
        view.addSubview(messageInputContainerView)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(inputTextField)
        
        messageInputCVBottomAnchor = messageInputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        messageInputCVBottomAnchor?.isActive = true
        messageInputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        messageInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor, constant: -5).isActive = true
        sendButton.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 5).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputTextField.delegate = self
        inputTextField.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor, constant: 5).isActive = true
        inputTextField.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 0).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: 0).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5).isActive = true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count)! > 0 {
            sendButton.isEnabled = true
            sendButton.setTitleColor(UIColor(red: 0, green: 139/255, blue: 249/255, alpha: 1), for: .normal)
        }
        return true
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        let message = fetchedResultsController.object(at: indexPath) as! Message
        cell.message = message
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text ?? "").width + 30
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let message = fetchedResultsController.object(at: indexPath) as? Message {
            if let messageText = message.text {
                 height = estimateFrameForText(text: messageText).height + 20
            }
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String)-> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}
