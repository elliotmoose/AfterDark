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
    
    var displayedCategory : Category?
    
    
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
                DispatchQueue.global(qos: .default).async{
                    
                    do
                    {
                        //data into dict

                        let dict = try JSONSerialization.jsonObject(with: output!, options: .allowFragments) as? NSDictionary
                        
                        if let _ = dict
                        {
                            if dict!["success"] as? String == "true"
                            {
                                //dict["detail"] = [dict] == [categoryDict]
                                
                                let categoryDictArray = dict!["detail"] as? [NSDictionary]
                                
                                guard categoryDictArray != nil else {return}
                                
                                
                                self.allCategories.removeAll()
                                
                                //FOR EACH NEW CAT
                                for catDict in categoryDictArray!
                                {
                                    let newCat = Category(dict: catDict)
                                    
                                    let name = newCat.name
                                    //load cat image
                                    //check if image exists in cache**************************************
                                    let image = CacheManager.singleton.categoryImages?[name] as? UIImage
                                    
                                    //if exists
                                    if let _ = image
                                    {
                                        //set image in imageView
                                        newCat.imageView?.image = image!
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
                                                let loadedImage = UIImage(data: output!)
                                                
                                                guard let _ = loadedImage else
                                                {
                                                    print("loaded image could not decode")
                                                    return
                                                }

                                                newCat.imageView?.image = loadedImage
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
                                                print("image load failed for category")
                                            }
                                            
                                        })
                                    }
                                    
                                    self.allCategories.append(newCat)
                                }
                                
                                CacheManager.singleton.Save()

                                
                            }
                        }
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        //reload displpay after load
                        self.delegate?.ReloadCategoriesView()
                    }
                    
                }
                
            }
            else
            {
                print("error: could not load all categories")
            }
        })
        
        
        
        
    }
    
    
}
