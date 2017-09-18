//
//  File.swift
//  ToDo
//
//  Created by Kaustubh on 18/09/17.
//  Copyright © 2017 Kaustubh. All rights reserved.
//

import Foundation
import RealmSwift

enum Status: String {
    case pending
    case completed
}

class Task: Object {
    dynamic var taskName = ""
    dynamic var createdAt = NSDate()
    dynamic var taskId = UUID().uuidString
    dynamic var status = Status.pending.rawValue
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
}
