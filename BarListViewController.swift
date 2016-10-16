//
//  BarListViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 14/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit
class BarListViewController: UITableViewController {
    
    var barDisplayMode: DisplayBarListMode = .alphabetical
    //on load
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do some task
            BarManager.singleton.LoadGenericData(self.displayBarList)

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
        tableView.registerNib(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")

    }

    func displayBarList() -> Void
    {
        //arrange before display
        BarManager.singleton.ArrangeBarList(barDisplayMode)
        
        //after arrange -> load
        self.ReloadTable()
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
        
        
        return cell
    }
}

