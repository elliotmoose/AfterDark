//
//  InitialViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 4/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController,LoggedInEventDelegate {

    static let singleton = InitialViewController()

    func hello(handler : @escaping () -> Void)
    {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Account.singleton.delegate = self
        Account.singleton.Load()
        
        //*******************************************************************
        //                  app start, main init throughout
        //*******************************************************************
        
        
        //step 1: check log in
        //login page
        var loggedIn = false //this is so that we can initialize before we load data in
        
        if Account.singleton.user_name == "" || Account.singleton.user_name == nil
        {
            loggedIn = false
        }
        else
        {
            loggedIn = true
        }
        
        
        
        //dummy app
        guard Settings.dummyAppOn == false else {
            DummyMode.singleton.Populate()
            PresentMainRootViewCont()
            return
        }
        
        if loggedIn
        {
            //step 2: if logged in, start loading (else log in page)
            self.hasLoggedIn()
        }
        else
        {
            if Settings.bypassLoginPage == false
            {
                PresentLoginViewCont()
            }
        }

        
    }

    //step 1: check log in
    //step 2: if logged in, start loading (else log in page)
    //step 3: "start loading" = check for cache
    //step 4: if has cache : check if needs updating 
        //step 4a: things to check : foreach barID : present? lastUpdateDate?
        //step 4b: loadAllBarNames : check if any new bars -> load from scratch -> cache
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    
    func PresentLoginViewCont()
    {
        let window = UIApplication.shared.delegate?.window!!
        window?.rootViewController = LoginViewController.singleton
    }
    
    
    func hasLoggedIn() {
        
        //step 3: "start loading" = check for cache ////// things not cached: discounts?, categories + images (bars in categories are loaded, however)
        //step 4: if has cache : check if needs updating (last upDate)
        //step 4a: things to check : foreach barID : isPresent? lastUpDate?
        //step 4b: loadAllBarIDs : check if any new bars -> load from scratch -> cache
        RetrieveDataFromUrls()
        LoadCachedData()
        PresentMainRootViewCont()
    }
    

    func RetrieveDataFromUrls()
    {
        //loading of data from internet******************************************************
        DispatchQueue.global(qos: .default).async{

            
            //init other views as this is the first view loaded
            BarManager.singleton.LoadGenericBarData({()->Void in
                
                //load bar details
                BarManager.singleton.LoadAllNonImageDetailBarData({()->Void in
                    
                })
                
                //load categories
                CategoriesManager.singleton.LoadAllCategories()
                
                //load reviews
                //ReviewManager.singleton.LoadAllReviews()
                
                //load discounts
                DiscountManager.singleton.LoadAllDiscounts()
                
                //load distancing
                BarManager.singleton.ReloadAllDistanceMatrix()
                
            })
            
        }
        
    }
    
    func LoadCachedData()
    {
        CacheManager.singleton.ClearCache()
        DispatchQueue.global(qos: .default).async{
            
            CacheManager.singleton.Load()
            
        }
    }

    
    func PresentMainRootViewCont()
    {
        let window = UIApplication.shared.delegate?.window!!
        window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        
    }

}
