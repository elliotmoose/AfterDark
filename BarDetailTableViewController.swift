//
//  BarDetailTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 16/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailTableViewController: UITableViewController {
    static let singleton = BarDetailTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialze()
    }

    func Initialze()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            //register nibs
            self.tableView.registerNib(UINib(nibName: "BarDetailViewController", bundle: nil), forCellReuseIdentifier: "BarDetailViewController")

        }
        dispatch_async(dispatch_get_main_queue(),
        {
                    self.view.backgroundColor = UIColor.blackColor()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

	//===============================================================================
	//											Cell
	//===============================================================================
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 && indexPath.row == 0
        {
           var cell = tableView.dequeueReusableCellWithIdentifier("GalleryCell")
           if cell == nil
	        {
	   	         cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
	        }        
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.text = ""
            
            return cell!
        }
			
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        cell!.backgroundColor = UIColor.clearColor()
        
        


        return cell!
    }
    
    //===============================================================================
    //											Height of Cells
    //===============================================================================
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //
        if indexPath.section == 0 && indexPath.row == 0
        {
            //height of gallery
            return Sizing.HundredRelativeHeightPts()*1.5
        }

        return 0
    }
    
    //============================================================================
    //                                  section header
    //============================================================================
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            let header = UIView()
            header.backgroundColor = UIColor.clearColor()
            return header

        }
        else
        {
            let headerHeight = self.tableView(self.tableView, heightForHeaderInSection: section)
            let header = BarDetailViewMainCell.init(frame: CGRectMake(0,0, Sizing.ScreenWidth(), headerHeight))
            header.Initialize()
            return header
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 44
        }
        let screenHeight = Sizing.ScreenHeight()
        //let fakeHeaderHeight = Sizing.HundredRelativeHeightPts()*2 /*if change this, remember to change view implementation of height*/
        return (screenHeight - 49/*tab bar height */ - self.navigationController!.navigationBar.frame.size.height ) /*- fake header height - nav bar height - tab bar height */
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
