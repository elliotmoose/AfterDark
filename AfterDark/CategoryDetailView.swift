//
//  CategoryDetailView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailView: UITableViewController {

    var displayedBars = [Bar]()
    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            //register bar list table view cell
            self.tableView.registerNib(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")
            
            self.tableView.rowHeight = 85
            
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedBars.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BarListTableViewCell", forIndexPath: indexPath) as! BarListTableViewCell

        let thisBar = displayedBars[indexPath.row]
        cell.SetContent(thisBar.icon, barName: thisBar.name, barRating: thisBar.rating)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //open bar detail view
    }
    

 
}
