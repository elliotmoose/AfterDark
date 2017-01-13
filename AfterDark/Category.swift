//
//  Category.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit
struct Category{
    var name : String = ""
    var barIDs = [String]()
    var imageView : UIImageView?
    var description : String = ""
    var lastUpdate : String = "Not Updated"
    
    var ID : String = ""
    init(dict : NSDictionary)
    {
        if let catName = dict["Category_Name"] as? String

        {
            name = catName
        }
        else
        {
            print("tried to init category without name")
            return
        }
        
        if let catDescription = dict["Category_Description"] as? String
        {
                description = catDescription
        }
        
        if let lastUpdated = dict["lastUpdate"] as? String
        {
            lastUpdate = lastUpdated
        }
        
        if let catID = dict["Category_ID"] as? String
        {
            ID = catID
        }
        else if let catID = dict["Category_ID"] as? Int
        {
            ID = "\(catID)"
        }
        
        if let jsonBarIDs = dict["Bar_IDs"] as? String
        {
            do
            {
                let bar_IDs = try JSONSerialization.jsonObject(with: (jsonBarIDs.data(using: .utf8))!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSArray
                
                guard bar_IDs != nil else {return}
                
                let barIntIDs = bar_IDs! as! [Int]
                
                for id in barIntIDs
                {
                    barIDs.append("\(id)")
                }
                
            }
            catch
            {
                //print("no bars in category")
            }
            
        }
        
        
        
        imageView = UIImageView()
        
    }
    
    init(name : String, barIDs : [String],description : String)
    {
        self.name = name
        self.barIDs = barIDs
        self.description = description
    }
    
}
