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


    }

    override func viewDidAppear(animated: Bool) {
        self.view.frame = Sizing.DetailTabViewFrame()
        self.tableView.frame = Sizing.DetailTabSubViewFrame()
        self.tableView.reloadData()
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
        let thisBarReview = BarManager.singleton.displayedDetailBar.reviews[indexPath.row]

        if cell == nil
        {
            cell = ReviewCell()
        }

        cell?.SetContent(thisBarReview.title, body: thisBarReview.description, avgRating: thisBarReview.rating.avg, priceRating: thisBarReview.rating.price, ambienceRating: thisBarReview.rating.ambience, serviceRating: thisBarReview.rating.service, foodRating: thisBarReview.rating.food)



        return cell!
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension + Sizing.HundredRelativeHeightPts()*2
        

    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension  + Sizing.HundredRelativeHeightPts()*2

    }

   
}

