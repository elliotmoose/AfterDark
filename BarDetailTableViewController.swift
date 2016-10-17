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
			
		 if indexPath.section == 1 && indexPath.row == 0
		 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BarDetailViewController",forIndexPath: indexPath)
            cell.backgroundColor = UIColor.greenColor()
	    	return  cell
		 }



        return UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
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
        let screenHeight = Sizing.ScreenHeight()
        let headerHeight = self.tableView(self.tableView, heightForHeaderInSection: indexPath.section)
        
        return (screenHeight - 49/*tab bar height */ - self.navigationController!.navigationBar.frame.size.height - headerHeight) /*- header height - nav bar height - tab bar height */
    }
    
    //============================================================================
    //                                  section header
    //============================================================================
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        if section == 0
        {
            header.backgroundColor = UIColor.clearColor()
        }
        else
        {
            header.backgroundColor = UIColor.redColor()
        }
        return header
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
