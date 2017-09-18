//
//  ViewController.swift
//  ToDo
//
//  Created by Kaustubh on 18/09/17.
//  Copyright © 2017 Kaustubh. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

enum FilterType {
    case dateAscending
    case dateDescending
    case alphabetically
}

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var filterType: FilterType = .dateDescending
    var tasks : Results<Task>!
    var completedTasks: Results<Task>!
    var pendingTasks: Results<Task>!
    var searchText = ""
    let filterCategories = ["Alphabetically", "Date asceneding", "Date descending"]
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDown.startListeningToKeyboard()
        self.setUpOrganizeFilter()
       dropDown.selectRow(at: 2)
    }

    func filterTasks()
    {
        var predicate = NSPredicate(format: "status == %@", "completed")
        if searchText.characters.count > 0
        {
            predicate = NSPredicate(format: "status == %@ AND taskName contains[c] %@", "completed", searchText)
        }
        self.completedTasks = self.tasks.filter(predicate)
        predicate = NSPredicate(format: "status == %@", "pending")
        if searchText.characters.count > 0
        {
            predicate = NSPredicate(format: "status == %@ AND taskName contains[c] %@", "pending", searchText)
        }
        self.pendingTasks = self.tasks.filter(predicate)
        switch self.filterType {
        case .dateDescending:
            self.pendingTasks = self.pendingTasks.sorted(byKeyPath: "createdAt", ascending:false)
            self.completedTasks = self.completedTasks.sorted(byKeyPath: "createdAt", ascending:false)
            self.dropDown.selectRow(at: 2)
            break
            
        case .dateAscending:
            self.pendingTasks = self.pendingTasks.sorted(byKeyPath: "createdAt", ascending:true)
            self.completedTasks = self.completedTasks.sorted(byKeyPath: "createdAt", ascending:true)
            self.dropDown.selectRow(at: 1)
            break
            
        case .alphabetically:
            self.pendingTasks = self.pendingTasks.sorted(byKeyPath: "taskName", ascending:true)
            self.completedTasks = self.completedTasks.sorted(byKeyPath: "taskName", ascending:true)
            self.dropDown.selectRow(at: 0)
            
            break
            
        }
        
        self.tableView.reloadData()
    }
    
    func setUpOrganizeFilter()
    {
        dropDown.direction = .bottom
        dropDown.anchorView = filterButton
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = filterCategories
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch index {
            case 0:
                self.filterType = FilterType.alphabetically
                
                break
            case 1:
                self.filterType = FilterType.dateAscending
                
                break
            case 2:
                self.filterType = FilterType.dateDescending
                
                break
            default: break
            }
            
            self.filterTasks()
        }
        
        dropDown.willShowAction = { [unowned self] in
            switch self.filterType {
            case .dateDescending:
                self.dropDown.selectRow(at: 2)
                break
            case .dateAscending:
                self.dropDown.selectRow(at: 1)
                break
            case .alphabetically :
                self.dropDown.selectRow(at: 0)
                break
            default: break
            }
        }
    
        dropDown.width = 200
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTasks()
    }

    func updateTasks()
    {
        tasks = uiRealm.objects(Task.self)
        self.filterTasks()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.characters.count >= 3
        {
            self.searchText = searchText
        }
        else
        {
            self.searchText = ""
            
        }
        
        if searchText.characters.count == 0
        {
            self.view.endEditing(true)
        }
        self.filterTasks()
    }
    
    func showAlertToAddATask(_ task:Task!){
        
        var title = "Create task"
        var doneTitle = "Create"
        var createMessage = "Create a task"
        if task != nil
        {
            title = "Update Task"
            doneTitle = "Update"
            createMessage = "Create a task"
            if task.status == Status.completed.rawValue
            {
                title = "Information"
                doneTitle = "Ok"
                createMessage = "Task Information"
            }
        }
        
        
        
        let alertController = UIAlertController(title: title, message: createMessage, preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) {[weak self] (action) -> Void in
            
            let tName = alertController.textFields?.first?.text
            
            if task != nil{
                ToDoManager.sharedInstance.update(taskId: task.taskId, taskName: tName!)
                self!.updateTasks()
            }
            else{
                
                ToDoManager.sharedInstance.addTask(name: tName!)
                self!.updateTasks()
            }
        }
        
        
        if task == nil || task.status == Status.pending.rawValue
        {
            alertController.addAction(createAction)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task Name"
            if task != nil{
                textField.text = task.taskName
                if task.status == Status.completed.rawValue
                {
                    textField.isEnabled = false
                }
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAlertToAddATask(nil)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem)
    {
        dropDown.show()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = self.pendingTasks.count
        if section == 1
        {
            count = self.completedTasks.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self))
        var task : Task
        
        if indexPath.section == 1
        {
           task = self.completedTasks[indexPath.row]
        }
        else
        {
            task =  self.pendingTasks[indexPath.row]
        }
        self.update(cell: cell as! TaskCell, task: task)
        return cell!
    }
    
    
    func update(cell: TaskCell, task: Task)
    {
        cell.taskNameLabel.text = task.taskName
        cell.taskId = task.taskId
        cell.delegate = self
        cell.radioButton.isEnabled = false
        cell.radioButton.indicatorColor = UIColor.blue
        cell.radioButton.iconColor = UIColor.gray
        
        cell.radioButton.isIconSquare = false
        cell.radioButton.isEnabled = true
        cell.radioButton.isSelected = true
        if task.status == Status.pending.rawValue
        {
            cell.radioButton.isSelected = false
            cell.completed = false
        }
        else
        {
            cell.completed = true
            cell.radioButton.isSelected = true
        }
    }
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title = "Pending"
        if section == 1
        {
            title = "Completed"
        }
        
        return title
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var task :Task
        if indexPath.section == 1
        {
            task = self.completedTasks[indexPath.row]
        }
        else
        {
            task = self.pendingTasks[indexPath.row]
        }
        
        self.showAlertToAddATask(task)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            var task :Task
            if indexPath.section == 1
            {
                task = self.completedTasks[indexPath.row]
            }
            else
            {
                task = self.pendingTasks[indexPath.row]
            }
            
            ToDoManager.sharedInstance.delete(task: task)
            
            self.updateTasks()
        }
    
    }
}

extension ViewController: TaskCellDelegate
{
    func completeTaskWithId(taskId: String)
    {
        ToDoManager.sharedInstance.completeTask(taskId: taskId)
        self.updateTasks()
    }
    
    
}

