//
//  TaskCell.swift
//  ToDo
//
//  Created by Kaustubh on 18/09/17.
//  Copyright © 2017 Kaustubh. All rights reserved.
//

import UIKit
import DLRadioButton
import RealmSwift

protocol TaskCellDelegate: class {
    func completeTaskWithId(taskId: String)
}

class TaskCell: UITableViewCell {

    @IBOutlet weak var radioButton: DLRadioButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    weak var delegate: TaskCellDelegate?
    var taskId = ""
    var completed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func radioButtonTapped()
    {
        if let cellDelegate = delegate
        {
            if self.completed == false
            {
                cellDelegate.completeTaskWithId(taskId: self.taskId)
            }
        }
    }

}
