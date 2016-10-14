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
    

    var barManager : BarManager
    
    //on load
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        
    }
    
    //on view appear
    override func viewDidAppear()
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Initialize()
    {
        barManager.Init()
    }



    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
    }
}

