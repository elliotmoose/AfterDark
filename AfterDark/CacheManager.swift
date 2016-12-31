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
    
    
    init()
    {
    }
    
    func Load()
    {
        guard Settings.ignoreUserDefaults == false else {return}
        //load categories images
        let UD = UserDefaults.standard
        
        let archivedData = UD.value(forKey: "Category_Images") as? Data
        
        if let archive = archivedData
        {
            let dict = NSKeyedUnarchiver.unarchiveObject(with: archive) as? NSMutableDictionary
            
            guard let _ = dict else
            {
                categoryImages = NSMutableDictionary()
                return
            }
            
            categoryImages = dict!
        }
        else
        {
            categoryImages = NSMutableDictionary()
        }
    }
    
    func Save()
    {
        
        
        let UD = UserDefaults.standard
        if categoryImages != nil
        {
            let archivedData = NSKeyedArchiver.archivedData(withRootObject: categoryImages!)
            UD.setValue(archivedData, forKey: "Category_Images")
        }
        else
        {
            categoryImages = NSMutableDictionary()
        }
    }
    
    func ClearCache()
    {
        let UD = UserDefaults.standard
        UD.set(nil, forKey: "Category_Images")
    }
}
