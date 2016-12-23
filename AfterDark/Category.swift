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
    init(dict : NSDictionary)
    {
        let catName = dict["Category_Name"] as? String
        if let _ = catName
        {
            name = catName!
        }
        else
        {
            print("tried to init category without name")
            return
        }
        
        let jsonBarIDs = dict["Bar_IDs"] as? String
        
        if let _ = jsonBarIDs
        {
            do
            {
                let bar_IDs = try JSONSerialization.jsonObject(with: (jsonBarIDs?.data(using: .utf8))!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSArray
                
                guard bar_IDs != nil else {return}
                
                let barIntIDs = bar_IDs! as! [Int]
                
                for id in barIntIDs
                {
                    barIDs.append("\(id)")
                }
                
            }
            catch let _ as NSError
            {
                print("no bar Id to parse")
            }
            
        }
        
        
        imageView = UIImageView()
        
    }
    
    init(name : String, barIDs : [String])
    {
        self.name = name
        self.barIDs = barIDs
    }
    
}
