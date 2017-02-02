//
//  CategoriesManager.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryManagerDelegate : class
{
    func ReloadCategoriesView()
    func ReloadCell(index: Int)
}
class CategoriesManager
{
    weak var delegate : CategoryManagerDelegate?
    static let singleton = CategoriesManager()
    var allCategories = [Category]()
    var displayedCategories = [Category]()
    
    var displayedCategory : Category?
    
    var loadCount = 0
    
    
    func LoadAllCategories()
    {
        let urlLoadAllCategories = Network.domain + "GetAllCategories.php"
        //dicitonary (success,detail)
        //          detail: array -> dictionaries=categories (Category_Name,Bar_IDs)
        //summary: dictionary -> array -> dictionary -> json_encoded array (Bar_IDs)
        
        Network.singleton.DataFromUrl(urlLoadAllCategories, handler: {
            (success,output) -> Void in
            if success && output != nil
            {
                
                do
                {
                    //data into dict
                    
                    if let dict = try JSONSerialization.jsonObject(with: output!, options: .allowFragments) as? NSDictionary
                    {
                        if let succ = dict["success"] as? String
                        {
                            if succ == "true"
                            {
                                //dict["detail"] = [dict] == [categoryDict]
                                
                                let categoryDictArray = dict["detail"] as? [NSDictionary]
                                
                                guard categoryDictArray != nil else {return}
                                
                                
                                self.allCategories.removeAll()
                                
                                //FOR EACH NEW CAT
                                for catDict in categoryDictArray!
                                {
                                    let newCat = Category(dict: catDict)
                                    
                                    let name = newCat.name
                                    //load cat image
                                    //check if image exists in cache**************************************
                                    if let image = CacheManager.singleton.categoryImages?[name] as? UIImage
                                    {
                                        //set image in imageView
                                        newCat.image = image
                                    }
                                    else
                                    {
                                        //if not -> begin image load****************************************
                                        let url = Network.domain + "Category_Images/\(name.AddPercentEncodingForURL(plusForSpace: true)!).jpg"
                                        Network.singleton.DataFromUrl(url, handler: {
                                            (success,output) -> Void in
                                            if success && output != nil
                                            {
                                                //output is image data
                                                if let loadedImage = UIImage(data: output!)
                                                {
                                                    newCat.image = loadedImage
                                                    //when done -> save image in cache ***
                                                    
                                                    CacheManager.singleton.categoryImages?.setValue(loadedImage, forKey: name)
                                                    
                                                    //update UI (get index -> delegat to collecionView and reload index)
                                                    for i in 0...self.allCategories.count-1
                                                    {
                                                        if self.allCategories[i].name == newCat.name
                                                        {
                                                            DispatchQueue.main.async {
                                                                self.delegate?.ReloadCell(index: i)
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    print("loaded image could not decode")
                                                    return
                                                }
                                                
                                                
                                                
                                            }
                                            else
                                            {
                                                print("image load failed for category")
                                            }
                                            
                                        })
                                    }
                                    
                                    self.allCategories.append(newCat)
                                }
                                
                                CacheManager.singleton.Save()
                            }
                            else
                            {
                                NSLog("invalid server response to load categories")
                            }
                            
                        }
                    }
                }
                catch let error as NSError
                {
                    print(error)
                }
                
                self.UpdateCategoriesUI()
                
                
            }
            else
            {
                print("error: could not load all categories")
            }
        })
        
        
        
        
    }
    
    //loading of categories
    //step 1: soft load -> cat names, bar IDs, lastUpDate (this is for images), barIDs are cached but always updated
    func SoftLoadAllCategories(_ handler : @escaping () -> Void)
    {
        let url = Network.domain + "SoftLoadAllCategories.php"
        
        Network.singleton.DataFromUrl(url) {
            (success, output) in
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let dictArr = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? [NSDictionary]
                        {
                            self.allCategories.removeAll()
                            
                            for dict in dictArr //each dict is a category
                            {
                                let newCat = Category(dict: dict)
                                self.allCategories.append(newCat)
                            }
                            
                            self.UpdateCategoriesUI()
                            
                            self.LoadCategoryImages()
                        }
                        else
                        {
                            NSLog("invalid server response")
                        }
                    }
                    catch
                    {
                        
                    }
                }
                else
                {
                    NSLog("Server fault: no server response")
                }
            }
            else
            {
                NSLog("Check connection")
                PopupManager.singleton.GlobalPopup(title: "ERROR", body: "Check Connection")
            }
            
            handler()
        }
        
    }
    
    func LoadCategoryImages() //includes cache check,cache excess removal, updates, check, and force loading
    {
        //reset
        self.loadCount = 0
        
        //safety 1.1
        if CacheManager.singleton.categoryImages == nil || CacheManager.singleton.catUpDates == nil || CacheManager.singleton.categoryImages!.count == 0 || CacheManager.singleton.catUpDates!.count == 0
        {
            //force load
            for category in self.allCategories
            {
                //step 2b & 3: update ui is included in function
                self.LoadImageForCategory(category: category)
                {
                    toSave in
                    
                    if toSave
                    {
                        self.loadCount += 1
                        self.SaveIfReady()
                    }
                }
            }
            
            return
        }
        

        
        for category in self.allCategories
        {
            //step 1: check cache for image
            if let image = CacheManager.singleton.categoryImages?[category.ID] as? UIImage
            {
                //step 1.5: check if image is outdated
                if let catOldUpdate = CacheManager.singleton.catUpDates?[category.ID] as? String
                {
                    if catOldUpdate == category.lastUpdate // if is updated
                    {
                        //step 2a: load image from cache
                        category.image = image
                        
                        //step 3: update ui
                        self.UpdateCategoryUI(category: category)
                        self.loadCount += 1
                        self.SaveIfReady()

                    }
                    else //if is outdated
                    {
                        //step 2b & 3: update ui is included in function
                        self.LoadImageForCategory(category: category)
                        {
                            toSave in
                            
                            if toSave
                            {
                                self.loadCount += 1
                                self.SaveIfReady()
                            }
                        }
                    }
                }
                else //if cant find last update
                {
                    //step 2b & 3: update ui is included in function
                    self.LoadImageForCategory(category: category)
                    {
                        toSave in
                        
                        if toSave
                        {
                            self.loadCount += 1
                            self.SaveIfReady()
                        }
                    }
                }
                
            }
            else //step 2b: if no image -> load image from server
            {
                //step 2b & 3: update ui is included in function
                self.LoadImageForCategory(category: category)
                {
                    toSave in
                    
                    if toSave
                    {
                        self.loadCount += 1
                        self.SaveIfReady()
                    }
                }
            }
            
        }
        

    }
    
    func SaveIfReady()
    {
        if loadCount == allCategories.count
        {
            CacheManager.singleton.Save()
        }
    }
    func LoadImageForCategory(category : Category, _ handler : @escaping (Bool) -> Void)
    {
        print("loading from internet")
        //if not -> begin image load****************************************
        let url = Network.domain + "Category_Images/\(category.name.AddPercentEncodingForURL(plusForSpace: true)!).jpg"
        Network.singleton.DataFromUrl(url, handler: {
            (success,output) -> Void in
            
            if success
            {
                if let output = output
                {
                    if let loadedImage = UIImage(data: output)
                    {
                        DispatchQueue.main.async {
                            //set image
                            category.image = loadedImage
                            //save image
                            CacheManager.singleton.categoryImages?.setValue(loadedImage, forKey: category.ID)
                            CacheManager.singleton.catUpDates?.setValue(category.lastUpdate, forKey: category.ID)
                            
                            handler(true)
                        }
                        
                        //update ui
                        self.UpdateCategoryUI(category: category)
                    }
                    else
                    {
                        NSLog("server fault: invalid image format")
                    }
                }
                else
                {
                    NSLog("server fault: no server response")
                }
            }
            else
            {
                NSLog("please check connection")
            }
            
        })
        
    }
    
    func UpdateCategoryUI(category : Category)
    {
        DispatchQueue.global(qos: .default).async {
                        
            guard self.displayedCategories.count != 0 else {return}
            
            //update UI (get index -> delegat to collecionView and reload index)
            for i in 0...self.displayedCategories.count-1
            {
                
                guard i < self.displayedCategories.count else {return}
                if self.displayedCategories[i].name == category.name
                {
                    DispatchQueue.main.async {
                        self.delegate?.ReloadCell(index: i)
                    }
                }
            }
            
        }
    }
    
    func UpdateCategoriesToDisplay() //removes categories that have no bars
    {
        displayedCategories.removeAll()
        for category in allCategories
        {
            if category.barIDs.count > 0
            {
                displayedCategories.append(category)
            }
        }
    }
    
    func UpdateCategoriesUI()
    {
        UpdateCategoriesToDisplay()
        
        //reload display after load
        self.delegate?.ReloadCategoriesView()
    }
}
