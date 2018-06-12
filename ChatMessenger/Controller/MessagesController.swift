//
//  MessagesController.swift
//  ChatMessenger
//
//  Created by Umar Yaqub on 30/04/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//

import UIKit
import CoreData

class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    private let cellId = "cellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
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
            self.collectionView?.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        self.navigationItem.title = "Messages"
        setupData()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add New", style: .plain, target: self, action: #selector(handleAdd))
    }
    
    @objc func handleAdd() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let dwayne = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        dwayne.name = "Dwayne Johnson"
        dwayne.profileImageName = "Dwayne-Johnson"
        MessagesController.createMessageWithText(text: "Hi, this is the rock", friend: dwayne, minutesAgo: 8 * 60 * 24, context: context)
        
        let kevin = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        kevin.name = "Kevin Hart"
        kevin.profileImageName = "Kevin-Hart"
        MessagesController.createMessageWithText(text: "Hi, this is Kevin Hart", friend: kevin, minutesAgo: 60 * 24, context: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                let entityNames = ["Friend", "Message"]
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    guard let objects = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
                    for object in objects {
                        context.delete(object)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    private func setupData() {
        clearData()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        // getting context from appdelegate
        if let context = delegate?.persistentContainer.viewContext {
            createPaulMessagesWithContext(context: context)
            createKohliMessageWithContext(context: context)
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    private func createKohliMessageWithContext(context: NSManagedObjectContext) {
        let kohli = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        kohli.name = "Virat Kohli"
        kohli.profileImageName = "Virat-Kohli"
        MessagesController.createMessageWithText(text: "Hi, this is Virat Kohli", friend: kohli, minutesAgo: 3, context: context)
        MessagesController.createMessageWithText(text: "I am a cricketer for India", friend: kohli, minutesAgo: 1, context: context)
        // response
        MessagesController.createMessageWithText(text: "Hi!", friend: kohli, minutesAgo: 2, context: context, isSender: true)
        MessagesController.createMessageWithText(text: "Nice to meet you", friend: kohli, minutesAgo: 0, context: context, isSender: true)
    }
    
    private func createPaulMessagesWithContext(context: NSManagedObjectContext) {
        let paul = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        paul.name = "Paul Pogba"
        paul.profileImageName = "Paul-Pogba"
        MessagesController.createMessageWithText(text: "Hi, this is Paul.", friend: paul, minutesAgo: 5, context: context)
        MessagesController.createMessageWithText(text: "How are you?.", friend: paul, minutesAgo: 3, context: context)
        MessagesController.createMessageWithText(text: "Nice to talk to you.", friend: paul, minutesAgo: 0, context: context)
        // response
        MessagesController.createMessageWithText(text: "Hi, this is me.", friend: paul, minutesAgo: 4, context: context, isSender: true)
        MessagesController.createMessageWithText(text: "I'm fine, thanks!", friend: paul, minutesAgo: 2, context: context, isSender: true)
    }
    
    static func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        friend.lastMessage = message
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        let friend = fetchedResultsController.object(at: indexPath) as! Friend
        cell.message = friend.lastMessage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        let friend = fetchedResultsController.object(at: indexPath) as! Friend
        chatLogController.friend = friend
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}

