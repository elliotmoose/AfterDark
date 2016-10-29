//
//  CategoriesManager.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
protocol CategoryManagerDelegate : class
{
    func ReloadCategoriesView()
}
class CategoriesManager
{
    weak var delegate : CategoryManagerDelegate?
    static let singleton = CategoriesManager()
    var allCategories = [Category]()
    func LoadAllCategories()
    {
        let urlLoadAllCategories = "http://mooselliot.net23.net/GetAllCategories.php"
        Network.singleton.DictArrayFromUrl(urlLoadAllCategories, handler: {
            (
            success,output) -> Void in
            
            if success
            {
                //reset
                self.allCategories.removeAll()
                
                for dict : NSDictionary in output
                {
                    //inputs category name
                    let name = dict["Category"]
                    if let name = name
                    {
                        var newCat = Category(dict: dict)
                        newCat.name = name as! String

                        //adds in the barIDs under the category from the output received
                        let bars = dict["Bar_IDs"]
                        if let bars = bars
                        {
                            if bars is [NSDictionary]
                            {
                                let barIDDictArray = bars as! [NSDictionary]
                                for barIDDict in barIDDictArray
                                {
                                    let barID = barIDDict["Bar_ID"]
                                    if barID is String
                                    {
                                        let newBarID = barID as! String
                                        newCat.barIDs.append(newBarID)
                                    }
                                }
                            }
                        }
                        
                        self.allCategories.append(newCat)
                        
                    }


                }
                
                
                self.delegate?.ReloadCategoriesView()
            }
            
            })
        
        
    }
    
    
}