//
//  ToDoManager.swift
//  ToDo
//
//  Created by Kaustubh on 18/09/17.
//  Copyright © 2017 Kaustubh. All rights reserved.
//

import Foundation
import RealmSwift

let uiRealm = try! Realm()

class ToDoManager{
    static let sharedInstance = ToDoManager()
    
    var tasks = uiRealm.objects(Task.self)
    
    public func getTasks(status: Status, searchText: String, filterType: FilterType) -> Results<Task>!
    {
        var tasksToReturn : Results<Task>!
        var predicate = NSPredicate(format: "status == %@", status.rawValue)
        if searchText.characters.count > 0
        {
            predicate = NSPredicate(format: "status == %@ AND taskName contains[c] %@", "completed", searchText)
        }
        tasksToReturn = self.tasks.filter(predicate)
        
        switch filterType {
        case .dateDescending:
            tasksToReturn = tasksToReturn.sorted(byKeyPath: "createdAt", ascending:false)
            
            break
            
        case .dateAscending:
            tasksToReturn = tasksToReturn.sorted(byKeyPath: "createdAt", ascending:true)
            break
            
        case .alphabetically:
            tasksToReturn = tasksToReturn.sorted(byKeyPath: "taskName", ascending:true)
            break
            
        }
        return tasksToReturn
    }
    
    public func getCompletedTasks() -> Results<Task>!
    {
        var tasksToReturn : Results<Task>!
        let predicate = NSPredicate(format: "status == %@", "completed")
        tasksToReturn = self.tasks.filter(predicate)
        return tasksToReturn
    }
    
    public func getPendingTasks() -> Results<Task>!
    {
        var tasksToReturn : Results<Task>!
        let predicate = NSPredicate(format: "status == %@", "pending")
        tasksToReturn = self.tasks.filter(predicate)
        return tasksToReturn
    }
    
    public func addTask(name: String)
    {
        let newtask = Task()
        newtask.taskName = name
        
        try! uiRealm.write{
            uiRealm.add(newtask)
        }
    }
    
    public func delete(task: Task)
    {
        try! uiRealm.write{
            
            uiRealm.delete(task)
        }
    }
    public func completeTask(taskId: String)
    {
        let predicate = NSPredicate(format: "taskId == %@", taskId)
        let filteredtasks = self.tasks.filter(predicate)
        if filteredtasks.count > 0
        {
            let tasktoComplete = filteredtasks.first
            try! uiRealm.write{
                tasktoComplete?.status = Status.completed.rawValue
            }
        }
    }
    
    public func update(taskId : String, taskName: String)
    {
        let predicate = NSPredicate(format: "taskId == %@", taskId)
        let filteredtasks = self.tasks.filter(predicate)
        if filteredtasks.count > 0
        {
            let tasktoComplete = filteredtasks.first
            try! uiRealm.write{
                tasktoComplete?.taskName = taskName
            }
        }
       
    }
}
