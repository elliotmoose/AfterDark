//
//  BarListViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 14/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit


class BarListTableViewController: UITableViewController,BarManagerToListTableDelegate {
    
    var barDisplayMode: DisplayBarListMode = .alphabetical
    var activityIndicator : UIActivityIndicatorView?
    var refreshButton : UIBarButtonItem?
    //on load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*******************************************************************
        //                  app start, main init throughout
        //*******************************************************************
        Initialize()
        
        //set opening page
        self.navigationController?.tabBarController?.selectedIndex = 1
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
//            let logCont = LoginViewController.singleton;
//            logCont.loginIconImageView.backgroundColor = UIColor.black
//            
//            Account.singleton.Load()
//            if Account.singleton.user_name == ""
//            {
//                self.present(logCont, animated: true, completion: nil)
//            }
            
            DispatchQueue.main.async(execute: {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
            })

            //init other views as this is the first up
            BarManager.singleton.LoadGenericBarData({()->Void in
                
                BarManager.singleton.LoadAllNonImageDetailBarData({()->Void in
                
                })
                
                CategoriesManager.singleton.LoadAllCategories()
                
                ReviewManager.singleton.LoadAllReviews()
                
                DiscountManager.singleton.LoadAllDiscounts()
                
                DispatchQueue.main.async(execute: {
                    self.navigationItem.rightBarButtonItem = self.refreshButton
                })

            })

        }

    }
    



    
    //on view appear
    func viewDidAppear()
    {
        BarDetailTableViewController.singleton.Initialze()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Initialize()
    {
        //ui init
        DispatchQueue.main.async {
            //set refresh button
            self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
            self.activityIndicator?.color = UIColor.gray
            self.activityIndicator?.startAnimating()
            self.refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(BarListTableViewController.refresh))
            self.navigationItem.rightBarButtonItem = self.refreshButton
            
        }
        
        //non ui init
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
        
            //register bar list table view cell
                self.tableView.register(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")
            
            //set self as bar manager delegate
            BarManager.singleton.listDelegate = self
            
        
        }
        



    }

    
    func UpdateBarListTableDisplay()

    {
        //arrange before display
        BarManager.singleton.ArrangeBarList(barDisplayMode)
        
        //after arrange -> load
        self.ReloadTable()
    }
    
    
    func UpdateCellForBar(_ bar : Bar)
    {
        //get bar indexPath in display Bar List
        var indexPath: IndexPath?
        for sectionIndex in 0...BarManager.singleton.displayBarList.count-1
        {
            let section = BarManager.singleton.displayBarList[sectionIndex]
            for rowIndex in 0...section.count-1
            {
                let barx = section[rowIndex]
                if bar.name == barx.name
                {
                    indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        
        if let indexPath = indexPath
        {
            //update that index path
            DispatchQueue.main.async {
                let indexPaths = [indexPath]
                self.tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.none)
                
                //check if its being viewed
                if BarManager.singleton.displayedDetailBar.name == bar.name
                {
                    //update that viewed details icon
                    BarDetailTableViewController.singleton.UpdateBarIcon()

                }
            }
        }


    }
    
    func ReloadTable()
    {
        DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }

    //============================================================================
    //                                 number of section and rows
    //============================================================================
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        let count = BarManager.singleton.displayBarList.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = BarManager.singleton.displayBarList[section].count

        return count
    }

    //============================================================================
    //                                create bar cells
    //============================================================================
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BarListTableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarListTableViewCell", for: indexPath) as! BarListTableViewCell
        let thisSection = BarManager.singleton.displayBarList[indexPath.section]
        let thisBar = thisSection[indexPath.row]
        
        cell.SetContent(thisBar.icon, barName: thisBar.name, barRating: thisBar.rating)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
    //============================================================================
    //                                 selected bar cell
    //============================================================================
    //show bar detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //prep for display
        BarManager.singleton.DisplayBarDetails(BarManager.singleton.displayBarList[indexPath.section][indexPath.row])
        BarDetailTableViewController.singleton.UpdateDisplays()
        self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
        

    }

    func refresh()
    {

        
        DispatchQueue.main.async(execute: {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
        })
        
        //init other views as this is the first up
        BarManager.singleton.LoadGenericBarData({()->Void in
            
            BarManager.singleton.LoadAllNonImageDetailBarData({()->Void in
                
            })
            
            ReviewManager.singleton.LoadAllReviews()
            
            DiscountManager.singleton.LoadAllDiscounts()
            
            DispatchQueue.main.async(execute: {
                self.navigationItem.rightBarButtonItem = self.refreshButton
            })
            
        })
    }
}

