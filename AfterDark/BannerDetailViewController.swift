//
//  BannerDetailViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 25/7/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit
//=========================================================================================================
// NOTE: THIS VIEW CONT'S ONLY PURPOSE IS TO MANIPULATE A NEW INSTANCE OF CATEGORYDETAILTABLEVIEWCONTROLLER()
//=========================================================================================================
class BannerDetailViewController: UIViewController,BarManagerToListTableDelegate {
    
    public static let singleton = BannerDetailViewController(nibName: "BannerDetailViewController", bundle: Bundle.main)
    
    let barListTableViewController = CategoryDetailTableViewController()
    
    var refreshButton = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "BannerDetailViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("BannerDetailViewController", owner: self, options: nil)
        
        
        //set up delegates
        BarManager.singleton.bannerListDelegate = self
        
        //navigation bar and tab bar init
        //nav bar and tab bar translucency for framing purposes
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        
        //colors
        self.navigationController?.navigationBar.tintColor = ColorManager.themeBright
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black;
        self.tabBarController?.tabBar.tintColor = ColorManager.themeBright
        
        //set up view
        self.addChildViewController(barListTableViewController)
        barListTableViewController.didMove(toParentViewController: self)
        view.addSubview(barListTableViewController.view)
        
        self.view.backgroundColor = UIColor.black
        
        refreshButton = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(Refresh))
        refreshButton.tintColor = ColorManager.themeBright
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
        activityIndicator.startAnimating()
        
        self.navigationItem.rightBarButtonItem = refreshButton
        
        //barListTableViewController.EnableSearchBar()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UpdateBarListTableDisplay()
    }
    
    func UpdateBarListTableDisplay() //this is called when data has been loaded
    {
        self.barListTableViewController.SetBarIDs(barIDs: BarManager.singleton.BarListIntoBarIDsList(BarManager.singleton.mainBarList))
    }
    
    
    func UpdateCellForBar(_ bar : Bar)
    {
        barListTableViewController.UpdateCellForBar(bar)
    }
    
    
    func Refresh()
    {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        
        BarManager.singleton.HardLoadAllBars {
            
            DiscountManager.singleton.LoadAllDiscounts()
            {
                    
            }
            
            BarManager.singleton.ReloadAllDistanceMatrix()
            
            self.navigationItem.rightBarButtonItem = self.refreshButton
        }
    }
    
    
    
}
