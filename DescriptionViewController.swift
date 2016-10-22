//
//  DescriptionTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()

    }


    func Initialize()
    {
       

        
        
        let mainViewHeight = Sizing.ScreenHeight() - Sizing.HundredRelativeHeightPts()*2/*gallery min height*/ - 49/*tab bar*/

        tableView = UITableView(frame: CGRectMake(0, 0,mainViewHeight,Sizing.ScreenWidth()))
    
        let tableViewBackGroundColor = UIColor.lightGrayColor()
        tableView?.backgroundColor = tableViewBackGroundColor
        
        self.view.addSubview(tableView!)

        tableView?.dataSource = self
        tableView?.delegate = self
        
        //register nibs
        //self.tableView!.registerClass(DescriptionCell.self, forCellReuseIdentifier: "DecsriptionCell")
        self.tableView!.registerNib(UINib(nibName: "DescriptionCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "DescriptionCell")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")

        switch indexPath
        {
        case NSIndexPath(forRow: 0, inSection: 0):
        
            let descriptionCell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DescriptionCell
            descriptionCell.descriptionBodyLabel.text = BarManager.singleton.displayedDetailBar.description
            descriptionCell.frame = CGRectMake(0, 0, Sizing.ScreenWidth(), Sizing.HundredRelativeHeightPts()*1.5)
            
            return descriptionCell
        case NSIndexPath(forRow: 1, inSection: 0):
            cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        case NSIndexPath(forRow: 2, inSection: 0):
            cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        case NSIndexPath(forRow: 3, inSection: 0):
            cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        default: cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        }

        return cell!
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath
        {
        case NSIndexPath(forRow: 0, inSection: 0):
            return Sizing.HundredRelativeHeightPts()*1.5
        default: return 30
        }
        
    }






    
}
