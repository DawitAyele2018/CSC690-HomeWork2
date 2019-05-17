//
//  Task.swift
//  myToDoLists
//
//  Created by Dawit Ayele on 5/6/19.
//  Copyright © 2019 Dawit Ayele. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding{
    var name:String?
    var isDone: Bool?
    
    private let nameKey = "name"
    private let isDoneKey = "isDone"
    
    init(name:String,isDone:Bool=false) {
        
        self.name = name
        self.isDone = isDone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(isDone, forKey: isDoneKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: nameKey) as? String,
            let isDone = aDecoder.decodeObject(forKey: isDoneKey) as? Bool
            else { return }
        
        // If successfully reads data from disk, set to object members
        self.name = name
        self.isDone = isDone
    }
}
