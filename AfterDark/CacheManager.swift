//
//  CacheManager.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/12/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit
class CacheManager
{
    static let singleton = CacheManager()
    
    var categoryImages : NSMutableDictionary?
    var catUpDates : NSMutableDictionary?
    //var cachedBarList : [Bar]?
    //var cachedCategoryList : [Category]?
    
    init()
    {
        categoryImages = NSMutableDictionary()
        catUpDates = NSMutableDictionary()
    }
    
    func Load()
    {
        guard Settings.ignoreUserDefaults == false else {return}
        
        
        if Settings.cacheModeOff
        {
            categoryImages = NSMutableDictionary()
            catUpDates = NSMutableDictionary()
            guard let categoryImages = categoryImages else {return}
            guard let catUpDates = catUpDates else {return}

            categoryImages["1"] = #imageLiteral(resourceName: "Craft Beers")
            categoryImages["2"] = #imageLiteral(resourceName: "Girls Night Out")
            categoryImages["3"] = #imageLiteral(resourceName: "Pre-Drinks")
            categoryImages["4"] = #imageLiteral(resourceName: "Classy")
            categoryImages["6"] = #imageLiteral(resourceName: "Cosy")
            categoryImages["7"] = #imageLiteral(resourceName: "Date")
            categoryImages["10"] = #imageLiteral(resourceName: "Sports")

            catUpDates["1"] = "0"
            catUpDates["2"] = "0"
            catUpDates["3"] = "0"
            catUpDates["4"] = "0"
            catUpDates["6"] = "0"
            catUpDates["7"] = "0"
            catUpDates["10"] = "0"
            
            return
        }
        
        
        //load categories images
        let UD = UserDefaults.standard
        
        let archivedImages = UD.value(forKey: "Category_Images") as? Data
        let archivedUpdates = UD.value(forKey: "Category_Updates") as? Data
        //let archivedBarListData = UD.value(forKey: "CachedBarList") as? Data
        if let images = archivedImages
        {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: images) as? NSDictionary
            {
                if let mutDict = dict.mutableCopy() as? NSMutableDictionary
                {
                    categoryImages = mutDict
                }
            }

        }

        //category last updates
        if let updates = archivedUpdates
        {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: updates) as? NSDictionary
            {
                if let mutDict = dict.mutableCopy() as? NSMutableDictionary
                {
                    catUpDates = mutDict
                }
            }
        }

        if self.categoryImages == nil
        {
            self.categoryImages = NSMutableDictionary()
        }
        
        if self.catUpDates == nil
        {
            self.catUpDates = NSMutableDictionary()
        }
        
        //ensures the information contained is in the right format 1.1
        var toReset = false
        for pair in self.categoryImages!
        {
            if let _ = pair.value as? UIImage
            {
                
            }
            else
            {
                NSLog("image corrupted")
                toReset = true
            }
        }
        
        for pair in self.catUpDates!
        {
            if let _ = pair.value as? String
            {
                
            }
            else
            {
                NSLog("image update string corrupted")
                toReset = true
            }
        }
        
        if toReset
        {
            NSLog("solving by resetting")
            self.categoryImages = NSMutableDictionary()
            self.catUpDates = NSMutableDictionary()
        }
        
    }
    
    func Save()
    {
        DispatchQueue.global(qos: .default).async {
            
            let UD = UserDefaults.standard
            
            if let catImages = self.categoryImages
            {
                let archivedData = NSKeyedArchiver.archivedData(withRootObject: catImages)
                UD.set(archivedData, forKey: "Category_Images")
            }
            else
            {
                self.categoryImages = NSMutableDictionary()
            }
            
            if let catUpdates = self.catUpDates
            {
                let archivedData = NSKeyedArchiver.archivedData(withRootObject: catUpdates)
                UD.set(archivedData, forKey: "Category_Updates")
            }
            else
            {
                self.catUpDates = NSMutableDictionary()
            }
            //
            //        //*** SAVES BASED ON MAIN BAR LIST
            //        if BarManager.singleton.mainBarList.count != 0
            //        {
            //            let archivedData = NSKeyedArchiver.archivedData(withRootObject: BarManager.singleton.mainBarList)
            //            UD.set(archivedData, forKey: "CachedBarList")
            //        }
            
            UD.synchronize()
        }
    }
    
    func ClearCache()
    {
        let UD = UserDefaults.standard
        UD.set(NSMutableDictionary(), forKey: "Category_Images")
        UD.set(NSMutableDictionary(), forKey: "Category_Updates")
    }
    
    //==============================================================================================================
    //                                                 BAR CACHE RELATED
    //==============================================================================================================
//    func HasBarCache() -> Bool
//    {
//        guard let barList = cachedBarList else {
//            cachedBarList = [Bar]()
//            return false
//        }
//        
//        if barList.count > 0
//        {
//            return true
//        }
//        else
//        {
//            return false
//        }
//
//    }
//    
    
    //==============================================================================================================
    //                                                 LOGIN RELATED
    //==============================================================================================================
    
    func RememberMeUsername() -> String?
    {
        let UD = UserDefaults.standard
        return UD.value(forKey: "rememberMeUsername") as? String
    }
    
    func SaveUsername(username : String)
    {
        let UD = UserDefaults.standard
        UD.setValue(username, forKey: "rememberMeUsername")
    }
    //HOW THIS WORKS:
    //caching splits to two : categories and bars
    
    //Categories: 

    //check if has cache -> no cache ->  softLoad() (hard without img) -> foreach -> hardLoad() -> barIDs, cat descrip, img
    //                      has cache -> load cache 
    //                                   softLoad() (hard without img) -> compare names
    ////                                                                 if has new names -> hardLoad()
    
    //Bars:
    //check if has cache -> no cache ->  softLoad() (hard without img) -> foreach -> hardLoad() -> barIDs, cat descrip, img
    //                      has cache -> load cache
    //                                   softLoad() (hard without img) -> compare names
    ////                                                                 if has new names -> hardLoad()
    //                                                                   old names -> compare lastUpDate ->if diff -> hardLoad
    //                                                                   all -> imagesLoaded?
    
    
    //keys: hasCategoryCache
    //keys: hasBarsCache
    //for each bar: cache bar - last update? images? discounts?
    //for each cat: cache cat
    
    
    
    
    
}
