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
       

        

        let mainViewHeight = Sizing.ScreenHeight() - Sizing.HundredRelativeHeightPts()*2/*gallery min height*/ - 49/*tab bar*/ - 88

        tableView = UITableView(frame: CGRectMake(0, 0,Sizing.ScreenWidth(),mainViewHeight))
    
        let tableViewBackGroundColor = ColorManager.descriptionCellBGColor
        tableView?.backgroundColor = tableViewBackGroundColor
        
        self.view.addSubview(tableView!)

        tableView?.dataSource = self
        tableView?.delegate = self
        
        //register nibs
        //self.tableView!.registerClass(DescriptionCell.self, forCellReuseIdentifier: "DecsriptionCell") IconCell
        self.tableView!.registerNib(UINib(nibName: "DescriptionCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "DescriptionCell")
        self.tableView!.registerNib(UINib(nibName: "IconCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "IconCell")

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")

        switch indexPath
        {
        case NSIndexPath(forRow: 0, inSection: 0):
        
            let descriptionCell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DescriptionCell
            descriptionCell.descriptionBodyLabel.text = BarManager.singleton.displayedDetailBar.description
            descriptionCell.frame = CGRectMake(0, 0, Sizing.ScreenWidth(), Sizing.HundredRelativeHeightPts()*1.5)
            descriptionCell.descriptionBodyLabel.textColor = ColorManager.descriptionCellTextColor
            descriptionCell.descriptionTitle.textColor = ColorManager.descriptionCellTextColor
            descriptionCell.backgroundColor = ColorManager.descriptionCellBGColor
            return descriptionCell
        case NSIndexPath(forRow: 1, inSection: 0):
            var cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Marker-48")?.imageWithRenderingMode(.AlwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            
            return cell!
        case NSIndexPath(forRow: 2, inSection: 0):
            var cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Clock-48")?.imageWithRenderingMode(.AlwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            
            if BarManager.singleton.displayedDetailBar.openClosingHours == nil
            {
                BarManager.singleton.displayedDetailBar.openClosingHours = "Unknown"
            }
            
            cell?.Detail.text = BarManager.singleton.displayedDetailBar.openClosingHours

            return cell!

        case NSIndexPath(forRow: 3, inSection: 0):
            var cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: NSIndexPath(forRow: 3, inSection: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Phone-48")?.imageWithRenderingMode(.AlwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            cell?.Detail.text = BarManager.singleton.displayedDetailBar.contact
            return cell!

        case NSIndexPath(forRow: 4, inSection: 0):
            var cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: NSIndexPath(forRow: 3, inSection: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Domain Filled-50")?.imageWithRenderingMode(.AlwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            
            return cell!

        default: cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
        }

        return cell!
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath
        {
        case NSIndexPath(forRow: 0, inSection: 0):
            return Sizing.HundredRelativeHeightPts()*1.5
        default: return 70
        }
        
    }






    
}
