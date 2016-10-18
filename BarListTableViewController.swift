//
//  BarListViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 14/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit


class BarListTableViewController: UITableViewController,BarManagerDelegate {
    
    var barDisplayMode: DisplayBarListMode = .alphabetical
    //on load
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do some task
            BarManager.singleton.LoadGenericBarData()

        }

    }
    



    
    //on view appear
    func viewDidAppear()
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Initialize()
    {
        //non ui init
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
            //register bar list table view cell
                self.tableView.registerNib(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")
            
            //set self as bar manager delegate
            BarManager.singleton.delegate = self
        
        }
        
        //ui init
        dispatch_async(dispatch_get_main_queue()) {
            //set refresh button
            let refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
            self.navigationItem.rightBarButtonItem = refreshButton
        
        }


    }

    
    func UpdateBarListTableDisplay()

    {
        //arrange before display
        BarManager.singleton.ArrangeBarList(barDisplayMode)
        
        //after arrange -> load
        self.ReloadTable()
    }
    
    func UpdateBarCellDisplayAtIndex(indexPath: NSIndexPath)
    {
        
        dispatch_async(dispatch_get_main_queue()) {
        let indexPaths = [indexPath]
        self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func ReloadTable()
    {
        dispatch_async(dispatch_get_main_queue()) {
        self.tableView.reloadData()
        }
    }

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
    
    //show bar detail view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
    }

    func refresh()
    {
        BarManager.singleton.LoadGenericBarData()
    }
}

