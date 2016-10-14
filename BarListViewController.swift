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
    
    
    //on load
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
       BarManager.singleton.LoadGenericData()
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
        
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return BarManager.singleton.displayBarList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BarManager.singleton.displayBarList[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BarCell", forIndexPath: indexPath) as UITableViewCell?
        
        
        return cell!
    }
}

