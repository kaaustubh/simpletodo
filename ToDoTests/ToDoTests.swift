//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Kaustubh on 18/09/17.
//  Copyright © 2017 Kaustubh. All rights reserved.
//

import XCTest
import RealmSwift
@testable import ToDo

class ToDoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.clearDatabase()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testAddNotes()
    {
        let taskName = "New Task abc"
        ToDoManager.sharedInstance.addTask(name: taskName)
        XCTAssertEqual(ToDoManager.sharedInstance.getPendingTasks().count, 1)
        XCTAssertEqual(ToDoManager.sharedInstance.getCompletedTasks().count, 0)
        let task = ToDoManager.sharedInstance.getPendingTasks()[0] as Task
        XCTAssertEqual(task.taskName, taskName)
        XCTAssertEqual(task.status, Status.pending.rawValue)
    }
    
    func testMarkTaskComplete()
    {
        let taskName = "New Task abc"
        ToDoManager.sharedInstance.addTask(name: taskName)
        XCTAssertEqual(ToDoManager.sharedInstance.getPendingTasks().count, 1)
        XCTAssertEqual(ToDoManager.sharedInstance.getCompletedTasks().count, 0)
        var task = ToDoManager.sharedInstance.getPendingTasks()[0] as Task
        
        ToDoManager.sharedInstance.completeTask(taskId: task.taskId)
        XCTAssertEqual(ToDoManager.sharedInstance.getPendingTasks().count, 0)
        XCTAssertEqual(ToDoManager.sharedInstance.getCompletedTasks().count, 1)
        
        task = ToDoManager.sharedInstance.getCompletedTasks()[0] as Task
        XCTAssertEqual(task.taskName, taskName)
        XCTAssertEqual(task.status, Status.completed.rawValue)
        
    }
    
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
