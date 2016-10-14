//
//  BarListViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 14/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit
import Bar

class BarListViewController: UITableViewController {
    
    //variables
    var mainBarList = [Bar]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize()
    {
        
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}

