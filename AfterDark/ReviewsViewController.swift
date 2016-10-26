//
//  ReviewsViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class ReviewsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func Initialize()
    {
        tableView.registerNib(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BarManager.singleton.displayedDetailBar.reviews.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as? ReviewCell
        
        if cell == nil
        {
				cell = ReviewCell()  
        }
        
        cell?.ReviewTitleLabel?.text = BarManager.singleton.displayedDetailBar.reviews[indexPath.row].title
        cell?.ReviewBodyLabel?.text = BarManager.singleton.displayedDetailBar.reviews[indexPath.row].description
        cell?.textLabel?.textColor = ColorManager.reviewTitleColor
        cell?.backgroundColor = ColorManager.reviewCellBGColor

        return cell!
    }
    

   
}
