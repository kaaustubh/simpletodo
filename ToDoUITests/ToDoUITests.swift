//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Kaustubh on 18/09/17.
//  Copyright © 2017 Kaustubh. All rights reserved.
//

import XCTest
import RealmSwift

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        self.clearDatabase()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTableViewSections()
    {
        let app = XCUIApplication()
        XCTAssert(app.tables.otherElements["Pending"].exists)
        XCTAssert(app.tables.otherElements["Completed"].exists)
        XCTAssertFalse(app.tables.otherElements["randomSection"].exists)
    }
    
    func testAppNotes() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.navigationBars["To Do List"].buttons["Add"].tap()
        app.alerts["Create task"].collectionViews.textFields["Task Name"].typeText("new task")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
        
        XCTAssertEqual(app.tables.element(boundBy: 0).cells.count, 1)
        XCTAssertEqual(app.tables.element(boundBy: 1).cells.count, 0)
        
    }
    
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
