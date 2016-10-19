//
//  BarDetailTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 16/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    static let singleton = BarDetailTableViewController()
    
    //variables
    var barIcon = UIImageView()
    var tableView = UITableView()
    var thisBar = Bar()
    var galleryCont = GalleryViewController.singleton

    //constants
    let minGalleryHeight = Sizing.HundredRelativeHeightPts()*2
    let maxGalleryHeight = Sizing.HundredRelativeHeightPts()*3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialze()
    }




    func Initialze()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            //register nibs
            self.tableView.registerNib(UINib(nibName: "BarDetailViewController", bundle: nil), forCellReuseIdentifier: "BarDetailViewController")
            
            
            //build layout
            let navBarHeight = self.navigationController!.navigationBar.frame.size.height
            let barIconWidth = self.minGalleryHeight/2
            
            self.tableView = UITableView.init(frame: CGRectMake(0, navBarHeight, Sizing.ScreenWidth(), Sizing.ScreenHeight() - navBarHeight - 49))
            self.barIcon = UIImageView.init(frame: CGRectMake((Sizing.ScreenWidth() - barIconWidth)/2 , (self.minGalleryHeight - barIconWidth)/2 + navBarHeight, barIconWidth,barIconWidth))
            self.galleryCont.view.frame = CGRectMake(0, navBarHeight, Sizing.ScreenWidth(), self.maxGalleryHeight)
            
            self.tableView.backgroundColor = UIColor.clearColor()
            self.barIcon.backgroundColor = UIColor.lightGrayColor()
            self.galleryCont.view.backgroundColor = UIColor.magentaColor()
            
            self.view.addSubview((self.galleryCont.view))
            self.view.addSubview(self.barIcon)
            self.view.addSubview(self.tableView)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
        }
        dispatch_async(dispatch_get_main_queue(),
        {
                    self.view.backgroundColor = UIColor.blackColor()
        })
    }

    func ToPresent(bar:Bar)
    {
        self.thisBar = bar
        
        dispatch_async(dispatch_get_main_queue(), {
            self.UpdateDisplays()
        })
    }
    //============================================================================
    //                                 update gallery, bar icon, tabs
    //============================================================================
    func UpdateDisplays()
    {
        self.UpdateBarIcon()
        self.UpdateGallery()
        self.UpdateTabs()
    }
    
    func UpdateBarIcon()
    {
        self.barIcon.image = thisBar.icon
    }
    
    func UpdateGallery()
    {
        
    }
    
    func UpdateTabs()
    {
        
    }
    // MARK: - Table view data source

    //============================================================================
    //                                 number of rows and sections
    //============================================================================
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

	//===============================================================================
	//									gallery and main detail view (CELLS)
	//===============================================================================
   
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 && indexPath.row == 0
//        {
//           var cell = tableView.dequeueReusableCellWithIdentifier("GalleryCell")
//           if cell == nil
//	        {
//	   	         cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
//	        }        
//            cell!.backgroundColor = UIColor.clearColor()
//            cell!.textLabel?.text = ""
//            
//            return cell!
//        }
			
        
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {


        return 0
    }
    
    //============================================================================
    //                                  section header
    //============================================================================
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    //============================================================================
    //                                  section header height
    //============================================================================
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            //height of gallery
            return maxGalleryHeight
        }
        let screenHeight = Sizing.ScreenHeight()

        return (screenHeight - 49/*tab bar height */ - self.navigationController!.navigationBar.frame.size.height - minGalleryHeight) /*screen height - nav bar height - tab bar height - min gallery height*/
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let y = -scrollView.contentOffset.y;
        if (y>0)
        {
            galleryCont.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)+y*CGRectGetWidth(self.view.frame)/330,y+330 )
            galleryCont.view.center = CGPointMake(self.view.center.x, galleryCont.view.center.y)
        }
        
        let x = scrollView.contentOffset.y - Sizing.HundredRelativeHeightPts()
        if(x < 0)
        {
            barIcon.alpha = (1 - (x/(-Sizing.HundredRelativeHeightPts())))
        }
    }

    
}
