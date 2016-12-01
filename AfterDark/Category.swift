//
//  Category.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation

struct Category{
    var name : String = ""
    var barIDs = [String]()
    
    init(dict : NSDictionary)
    {
        
    }
    
    init(name : String, barIDs : [String])
    {
        self.name = name
        self.barIDs = barIDs
    }
}
