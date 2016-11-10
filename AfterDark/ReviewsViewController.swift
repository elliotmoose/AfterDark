//
//  ReviewsViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class ReviewsViewController: UITableViewController {

    var allCells = [ReviewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.frame = Sizing.DetailTabViewFrame()
        self.tableView.frame = Sizing.DetailTabSubViewFrame()
        
        for cell in allCells
        {
            cell.isExpanded = false
            cell.CollapseCell()
        }
        
        self.tableView.reloadData()
    }

    
    func Initialize()
    {
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BarManager.singleton.displayedDetailBar.reviews.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create add review cell
        if indexPath == IndexPath(row: 0, section: 0)
        {
            let cell = Bundle.main.loadNibNamed("AddReviewTableViewCell", owner: self, options: nil)?[0] as? AddReviewTableViewCell
            
            
            
            
            
            return cell!
        }
        
        
        
        var cell : ReviewCell?
        if indexPath.row - 1 < allCells.count
        {
            cell = allCells[indexPath.row - 1]
        }
        else
        {
            cell = Bundle.main.loadNibNamed("ReviewCell", owner: self, options: nil)?[0] as? ReviewCell

            //cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as? ReviewCell
            allCells.append(cell!)
        }
        
        
        let thisBarReview = BarManager.singleton.displayedDetailBar.reviews[indexPath.row - 1]

 

        cell?.SetContent(thisBarReview.title, body: thisBarReview.description, avgRating: thisBarReview.rating.avg, priceRating: thisBarReview.rating.price, ambienceRating: thisBarReview.rating.ambience, serviceRating: thisBarReview.rating.service, foodRating: thisBarReview.rating.food)



        return cell!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row  == 0 //*** required otherwise index out of range for below statements
        {
            return 250
        }
        
        var thisCell : ReviewCell?
        if indexPath.row - 1 < allCells.count
        {
            thisCell = allCells[indexPath.row - 1]
        }
        else
        {
            thisCell = Bundle.main.loadNibNamed("ReviewCell", owner: self, options: nil)?[0] as? ReviewCell
            allCells.append(thisCell!)
        }
        
        if thisCell!.isExpanded
        {
            //then give expanded height
            return UITableViewAutomaticDimension + Sizing.HundredRelativeHeightPts()*2.3
        }
        else
        {
            //give collapsed height
            return UITableViewAutomaticDimension + Sizing.HundredRelativeHeightPts()*1.3
        }
        
        
        

    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row  == 0 //*** required otherwise index out of range for below statements
        {
            return 250
        }
        
        var thisCell : ReviewCell?
        if indexPath.row - 1 < allCells.count
        {
            thisCell = allCells[indexPath.row - 1]
        }
        else
        {
            thisCell = Bundle.main.loadNibNamed("ReviewCell", owner: self, options: nil)?[0] as? ReviewCell

            allCells.append(thisCell!)
        }
        
        
        if thisCell!.isExpanded
        {
            //then give expanded height
            return UITableViewAutomaticDimension + Sizing.HundredRelativeHeightPts()*2.3
        }
        else
        {
            //give collapsed height
            return UITableViewAutomaticDimension + Sizing.HundredRelativeHeightPts()*1.3
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row  == 0 //*** required otherwise index out of range for below statements
        {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        var thisCell : ReviewCell?
        
        if indexPath.row - 1 < allCells.count
        {
            thisCell = allCells[indexPath.row - 1]
        }
        else
        {
            thisCell = Bundle.main.loadNibNamed("ReviewCell", owner: self, options: nil)?[0] as? ReviewCell
            allCells.append(thisCell!)
        }
        
        if thisCell!.isExpanded
        {
            //collapse
            thisCell!.isExpanded = false
            thisCell!.CollapseCell()
        }
        else
        {
            //expand
            thisCell!.isExpanded = true
            thisCell!.ExpandCell()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}

