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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //*******************************************************************
        //                  app start, main init throughout
        //*******************************************************************
        
        //login page
        var loggedIn = false //this is so that we can initialize before we load data in
        Account.singleton.delegate = self
        Account.singleton.Load()
        if Account.singleton.user_name == "" || Account.singleton.user_name == nil
        {
            if !Settings.bypassLoginPage
            {
                PresentLoginViewCont()
            }
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
            self.hasLoggedIn()
        }
        

    
    
    }

    
    func hasLoggedIn() {
        RetrieveDataFromUrls()
        LoadCachedData()
        
        PresentMainRootViewCont()
    }
    
    func PresentMainRootViewCont()
    {
        let window = UIApplication.shared.delegate?.window!!
        window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        
    }
    
    func PresentLoginViewCont()
    {
        let window = UIApplication.shared.delegate?.window!!
        window?.rootViewController = LoginViewController.singleton
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
                ReviewManager.singleton.LoadAllReviews()
                
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


}
