//
//  ReviewsViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol AddReviewCellDelegate : class {
    func ShowAddDetailReviewController()
    func HideAddDetailReviewController()
    func ReloadReviewTableData()
}

class ReviewsViewController: UIViewController,AddReviewCellDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var allCells = [ReviewCell]()
    var addReviewCell : AddReviewTableViewCell?;
    var delegate : TabDelegate?
    
    var displayReviews = [Review]()
    var hasGivenReviewForThisBar = false
    var myReview : Review?
    
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //        let detailTabViewFrame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.mainViewHeight)
        //        self.view.frame = detailTabViewFrame
        //        self.tableView.frame = detailTabViewFrame
        
        for cell in allCells
        {
            cell.isExpanded = false
            cell.CollapseCell()
        }
        
        //reload tableview
        ReloadReviewTableData()
        
    }
    
    func ReloadReviewTableData()
    {
        //first get reviews to display
        guard let _ = BarManager.singleton.displayedDetailBar else {return}
        
        displayReviews = BarManager.singleton.displayedDetailBar!.reviews
        
        if displayReviews.count <= 0
        {
            print("ERROR: Cant Load: no reviews to load")
            return
        }
        
        //first check if you have a review for this bar
        hasGivenReviewForThisBar = false
        
        var indexOfMyReview = -1
        for x in 0...(displayReviews.count - 1)
        {
            guard x < displayReviews.count else {break}
            
            let review = displayReviews[x]
            
            if review.user_name == Account.singleton.user_name
            {
                //set variable
                hasGivenReviewForThisBar = true
                
                //set my review
                myReview = review
                
                //set up removal
                indexOfMyReview = x
            }
        }
        
        if indexOfMyReview != -1
        {
            //then remove your review from the displayed reviews
            displayReviews.remove(at: indexOfMyReview)
        }
        
        //then reload the data
        self.tableView?.reloadData()
        
    }
    func Initialize()
    {
        tableView = UITableView(frame: CGRect(x: 0, y: 0,width: Sizing.ScreenWidth(),height: Sizing.mainViewHeight))
        tableView?.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.tableView?.autoresizesSubviews = false
        
        
        tableView?.backgroundColor = UIColor.black
        self.view.addSubview(tableView!)
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    
    
    //=======================================================================================
    //                                  number of rows/sections
    //=======================================================================================
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayReviews.count + 1
    }
    
    //=======================================================================================
    //                                  cell for row
    //=======================================================================================
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create add review cell
        if indexPath == IndexPath(row: 0, section: 0)
        {
            if hasGivenReviewForThisBar
            {
                let cell = Bundle.main.loadNibNamed("ReviewCell", owner: self, options: nil)?[0] as? ReviewCell
                
                
                if let myReview = myReview
                {
                    cell?.SetContent(myReview.title, body: myReview.description, avgRating: myReview.rating.avg, priceRating: myReview.rating.price, ambienceRating: myReview.rating.ambience, serviceRating: myReview.rating.service, foodRating: myReview.rating.food,username: myReview.user_name)
                }
                cell?.collapseIndicator.alpha = 0
                cell?.ExpandCell()
                return cell!
                
            }
            else
            {
                let cell = Bundle.main.loadNibNamed("AddReviewTableViewCell", owner: self, options: nil)?[0] as? AddReviewTableViewCell
                
                self.addReviewCell = cell;
                cell?.delegate = self
                
                return cell!
            }
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
        
        
        let thisBarReview = displayReviews[indexPath.row - 1]
        
        cell?.SetContent(thisBarReview.title, body: thisBarReview.description, avgRating: thisBarReview.rating.avg, priceRating: thisBarReview.rating.price, ambienceRating: thisBarReview.rating.ambience, serviceRating: thisBarReview.rating.service, foodRating: thisBarReview.rating.food,username: thisBarReview.user_name)
        
        
        
        return cell!
    }
    
    
    
    //=======================================================================================
    //                                  height for row
    //=======================================================================================
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row  == 0 //*** required otherwise index out of range for below statements
        {
            
            if hasGivenReviewForThisBar
            {
                return Sizing.cellUnexpandedHeight + Sizing.cellExpansionDiff
            }
            else
            {
                return 100
            }
            
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
            return Sizing.cellUnexpandedHeight + Sizing.cellExpansionDiff
        }
        else
        {
            //give collapsed height
            return Sizing.cellUnexpandedHeight
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row  == 0 //*** required otherwise index out of range for below statements
        {
            if hasGivenReviewForThisBar
            {
                return Sizing.cellUnexpandedHeight + Sizing.cellExpansionDiff
            }
            else
            {
                return 100
            }
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
            return Sizing.cellUnexpandedHeight + Sizing.cellExpansionDiff
        }
        else
        {
            //give collapsed height
            return Sizing.cellUnexpandedHeight
        }
    }
    
    
    //=======================================================================================
    //                                  select row
    //=======================================================================================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    //methods for add review detailed controller (coming from review cell)
    func ShowAddDetailReviewController()
    {
        guard let _ = BarManager.singleton.displayedDetailBar else {return}
        self.delegate?.NavCont().pushViewController(AddDetailedReviewViewController.singleton, animated: true)
        self.delegate?.NavCont().navigationBar.topItem?.title = BarManager.singleton.displayedDetailBar!.name
    }
    
    func HideAddDetailReviewController()
    {
        let _ = self.delegate?.NavCont().popViewController(animated: true)
    }
    
}

