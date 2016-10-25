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
        
        Initialize()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {


            
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
            })

            //init other views as this is the first up
            BarManager.singleton.LoadGenericBarData({()->Void in
                
                BarManager.singleton.LoadAllNonImageDetailBarData({()->Void in
                
                })
                
                   //load reviews
            ReviewManager.singleton.LoadReviews(bar, )
                
                dispatch_async(dispatch_get_main_queue(), {
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
        dispatch_async(dispatch_get_main_queue()) {
            //set refresh button
            self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,20,20))
            self.activityIndicator?.color = UIColor.grayColor()
            self.activityIndicator?.startAnimating()
            self.refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
            self.navigationItem.rightBarButtonItem = self.refreshButton
            
        }
        
        //non ui init
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
            //register bar list table view cell
                self.tableView.registerNib(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")
            
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
    
    
    func UpdateCellForBar(bar : Bar)
    {
        //get bar indexPath in display Bar List
        var indexPath: NSIndexPath?
        for sectionIndex in 0...BarManager.singleton.displayBarList.count-1
        {
            let section = BarManager.singleton.displayBarList[sectionIndex]
            for rowIndex in 0...section.count-1
            {
                let barx = section[rowIndex]
                if bar.name == barx.name
                {
                    indexPath = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                }
            }
        }
        
        if let indexPath = indexPath
        {
            //update that index path
            dispatch_async(dispatch_get_main_queue()) {
                let indexPaths = [indexPath]
                self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
                
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
        dispatch_async(dispatch_get_main_queue()) {
        self.tableView.reloadData()
        }
    }

    //============================================================================
    //                                 number of section and rows
    //============================================================================
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        let count = BarManager.singleton.displayBarList.count
        return count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = BarManager.singleton.displayBarList[section].count

        return count
    }

    //============================================================================
    //                                create bar cells
    //============================================================================
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BarListTableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BarListTableViewCell", forIndexPath: indexPath) as! BarListTableViewCell
        let thisSection = BarManager.singleton.displayBarList[indexPath.section]
        let thisBar = thisSection[indexPath.row]
        
        cell.bar_NameLabel?.text = thisBar.name
        cell.bar_RatingLabel.text = String(format: "%.1f",thisBar.rating.avg)
        cell.bar_Icon.image = thisBar.icon
        cell.bar_Icon.layer.masksToBounds = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
    
    //============================================================================
    //                                 selected bar cell
    //============================================================================
    //show bar detail view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //prep for display
        BarManager.singleton.DisplayBarDetails(BarManager.singleton.displayBarList[indexPath.section][indexPath.row])
        BarDetailTableViewController.singleton.UpdateDisplays()
        self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
        

    }

    func refresh()
    {

        
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
        })
        
        //init other views as this is the first up
        BarManager.singleton.LoadGenericBarData({()->Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationItem.rightBarButtonItem = self.refreshButton
            })
            
        })
    }
}

