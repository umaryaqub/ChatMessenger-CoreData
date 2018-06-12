//
//  MainTabBarController.swift
//  ChatMessenger
//
//  Created by Umar Yaqub on 04/05/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messagesController = MessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        let recentMessagesNavigationController = UINavigationController(rootViewController: messagesController)
        recentMessagesNavigationController.tabBarItem.image = UIImage(named: "Messages")
        
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(named: "Friends")
        
        viewControllers = [recentMessagesNavigationController, nav]
    }
}
