//
//  TaskStore.swift
//  myToDoLists
//
//  Created by Dawit Ayele on 5/6/19.
//  Copyright © 2019 Dawit Ayele. All rights reserved.
//

import Foundation

class TaskStore {
    var tasks = [[Task](),[Task]()]
    
    // add task
    
    func add(_ task: Task, at index: Int, isDone:Bool=false){
        
        let section = isDone ? 1: 0
        
        tasks[section].insert(task, at: index)
    }
    
    //remove task
    
    @discardableResult func removeTask(at index: Int, isDone:Bool=false) -> Task{
        
        let section = isDone ? 1:0
        
        return tasks[section].remove(at: index)
    }
}
