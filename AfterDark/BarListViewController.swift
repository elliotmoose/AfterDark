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
        
        self.view.backgroundColor = UIColor.red

        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateBarListTableDisplay()
    }

    func UpdateBarListTableDisplay() //this is called when data has been loaded
    {
        //step 1: load all bar IDs into display
        //step 2: call the arrangement function
        //step 3: reload table view
        //{function does step 1,2 and 3 simultaneously}
        
        barListTableViewController.SetArrangementWithBarList(arrangement: .nearby, barListInput: BarManager.singleton.mainBarList)
        
    }
    
    
    func UpdateCellForBar(_ bar : Bar)
    {
        barListTableViewController.UpdateCellForBar(bar)
    }
    
    
}
