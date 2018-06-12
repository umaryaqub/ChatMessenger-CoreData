//
//  Message+CoreDataProperties.swift
//  ChatMessenger
//
//  Created by Umar Yaqub on 07/05/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var friend: Friend?

}
