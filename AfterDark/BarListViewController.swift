//
//  BarListViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 4/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit
//=========================================================================================================
// NOTE: THIS VIEW CONT'S ONLY PURPOSE IS TO MANIPULATE A NEW INSTANCE OF CATEGORYDETAILTABLEVIEWCONTROLLER()
//=========================================================================================================
class BarListViewController: UIViewController,BarManagerToListTableDelegate {

    let barListTableViewController = CategoryDetailTableViewController()
    
    var refreshButton = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up delegates
        BarManager.singleton.listDelegate = self
        
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
    override func viewWillAppear(_ animated: Bool) {
        UpdateBarListTableDisplay()
    }

    func UpdateBarListTableDisplay() //this is called when data has been loaded
    {
        self.barListTableViewController.SetBarIDsFromList(barListInput: BarManager.singleton.mainBarList)        
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
            
            BarManager.singleton.ReloadAllDistanceMatrix()
            
            self.navigationItem.rightBarButtonItem = self.refreshButton
        }
    }
    
    
    
}
