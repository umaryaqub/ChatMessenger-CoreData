//
//  ChatMessengerTests.swift
//  ChatMessengerTests
//
//  Created by Umar Yaqub on 30/04/2018.
//  Copyright © 2018 Umar Yaqub/Luke Dean. All rights reserved.
//

import XCTest
@testable import ChatMessenger

class ChatMessengerTests: XCTestCase {
    
    var messagesController: MessagesController?
    
    override func setUp() {
        super.setUp()
        
        messagesController = MessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        // making sure view is loaded
        let _ = messagesController?.view
    }
    
    // navigation bar title
    func testNavigationTitleText() {
        XCTAssertEqual("Messages", messagesController?.navigationItem.title)
    }
    
    // right bar button
    func testHasRightBarButtonItem() {
        XCTAssertNotNil(messagesController?.navigationItem.rightBarButtonItem)
    }
    func testRightBarButtonTitleText() {
        XCTAssertEqual("Add New", messagesController?.navigationItem.rightBarButtonItem?.title)
    }
    func testRightBarButtonTargetIsAssigned() {
        if let rightBarButtonItem = messagesController?.navigationItem.rightBarButtonItem {
            XCTAssertNotNil(rightBarButtonItem.target)
            XCTAssert(rightBarButtonItem.target === self.messagesController)
        } else {
            XCTAssertTrue(false)
        }
    }
    func testRightBarButtonActionMethodIsAssigned() {
        if let rightBarButtonItem = messagesController?.navigationItem.rightBarButtonItem {
            XCTAssertTrue(rightBarButtonItem.action?.description == "handleAdd")
        } else {
            XCTAssertTrue(false)
        }
    }
    func testCollectionViewIsInitialised() {
        XCTAssertNotNil(messagesController?.collectionView)
    }
    func testCollectionViewCellForItemAtIndexPath() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = messagesController?.collectionView((messagesController?.collectionView)!, cellForItemAt: indexPath) as! MessageCell
        XCTAssertEqual(cell.nameLabel.text, "Virat Kohli")
        XCTAssertEqual(cell.message?.friend?.profileImageName, "Virat-Kohli")
    }
    func testRightBarButtonActionIsAsExpected() {
        messagesController?.handleAdd()
        
        let indexPath = IndexPath(item: 2, section: 0)
        let cell = messagesController?.collectionView((messagesController?.collectionView)!, cellForItemAt: indexPath) as! MessageCell
        XCTAssertEqual(cell.nameLabel.text, "Kevin Hart")
        
    }
    
    override func tearDown() {
        messagesController = nil
        super.tearDown()
    }
 
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
