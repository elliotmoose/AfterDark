//
//  BarDetailTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 16/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,BarManagerToDetailTableDelegate,ReviewManagerToBarDetailContDelegate {
    static let singleton = BarDetailTableViewController()
    
    //UI object variables
    var barIcon = UIImageView()
    var barIconButton = UIButton()
    var tableView = UITableView()
    var blurrView = UIVisualEffectView()
    var mainBarDetailViewCell:BarDetailViewMainCell?
    
    
    //view controllers
    var galleryCont = GalleryViewController.singleton
    
    //constants
    let minGalleryHeight = Sizing.HundredRelativeHeightPts()*2
    let maxGalleryHeight = Sizing.HundredRelativeHeightPts()*3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialze()
    }

    
    override func viewWillAppear(animated: Bool) {
        

        self.UpdateBarIcon()
        self.UpdateReviewTab()
        
        mainBarDetailViewCell?.CellWillAppear()
        galleryCont.ToPresentNewDetailBar()


    }

    override func viewDidAppear(animated: Bool) {
        //reset layouts
        self.barIcon.alpha = 1
        let bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height);
        self.tableView.setContentOffset(bottomOffset, animated: true)
        
        self.UpdateBarIcon()
        self.UpdateReviewTab()
        
        self.blurrView.effect = nil
        UIView.animateWithDuration(1.0, animations: {
            self.blurrView.effect = UIBlurEffect(style: .Light)
        })
    }
    func Initialze()
    {

        dispatch_async(dispatch_get_main_queue(),
        {
            //register nibs
            self.tableView.registerNib(UINib(nibName: "BarDetailViewController", bundle: nil), forCellReuseIdentifier: "BarDetailViewController")
            
            //initialize controllers

            
            
            
            //build layout
            let navBarHeight = self.navigationController!.navigationBar.frame.size.height
            let barIconWidth = self.minGalleryHeight/2
            
            self.tableView = UITableView.init(frame: CGRectMake(0, navBarHeight, Sizing.ScreenWidth(), Sizing.ScreenHeight() - navBarHeight - 49))
            self.barIcon = UIImageView.init(frame: CGRectMake((Sizing.ScreenWidth() - barIconWidth)/2 , (self.minGalleryHeight - barIconWidth)/2 + navBarHeight, barIconWidth,barIconWidth))
            self.barIconButton = UIButton.init(frame: CGRectMake((Sizing.ScreenWidth() - barIconWidth)/2 , (self.minGalleryHeight - barIconWidth)/2 + navBarHeight, barIconWidth,barIconWidth))
            //must set frame first
            self.galleryCont.view.frame = CGRectMake(0, navBarHeight, Sizing.ScreenWidth(), self.maxGalleryHeight)
            self.galleryCont.Initialize()
            
            //self.blurrView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            self.blurrView = UIVisualEffectView(effect: nil)
            self.blurrView.frame = CGRectMake(0, navBarHeight, Sizing.ScreenWidth(), self.maxGalleryHeight)
            self.blurrView.layer.speed = 0

            
            self.tableView.backgroundColor = UIColor.clearColor()
            self.barIcon.backgroundColor = UIColor.blackColor()
            self.barIconButton.backgroundColor = UIColor.clearColor()
            self.galleryCont.view.backgroundColor = ColorManager.galleryBGColor
            
            self.barIcon.contentMode = UIViewContentMode.ScaleAspectFit
            self.barIcon.layer.cornerRadius = barIconWidth/2
            self.barIcon.layer.masksToBounds = true
            self.barIconButton.layer.cornerRadius = barIconWidth/2
            self.barIconButton.layer.masksToBounds = true
            
            self.view.addSubview((self.galleryCont.view))
            self.view.addSubview(self.blurrView)

            self.view.addSubview(self.tableView)
            self.view.addSubview(self.barIcon)
            self.view.addSubview(self.barIconButton)
            
            self.addChildViewController(self.galleryCont)
            self.galleryCont.didMoveToParentViewController(self)
            
            BarManager.singleton.detailDelegate = self
            ReviewManager.singleton.delegate = self
            self.tableView.dataSource = self
            self.tableView.delegate = self
        

            self.barIconButton.addTarget(self, action: "BarIconTapped", forControlEvents: UIControlEvents.TouchUpInside)
            //0 means not zoomed in
            self.barIconButton.tag = 0
            
            
            
            
            
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
        barIcon.image = BarManager.singleton.displayedDetailBar.icon
    }
    
    func UpdateGallery()
    {
        
    }
    
    func UpdateTabs()
    {
        UpdateDescriptionTab()
        UpdateReviewTab()
    }
    
    func UpdateDescriptionTab()
    {
        //update bar description tab
        dispatch_async(dispatch_get_main_queue(), {
        self.mainBarDetailViewCell?.descriptionCont.tableView?.reloadData()
        })
    }
    
    func UpdateReviewTab()
    {
        dispatch_async(dispatch_get_main_queue(), {
                self.mainBarDetailViewCell?.reviewCont.tableView.reloadData()
            })

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
    //                                  Main Display (Headers)
    //============================================================================
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            let header = TransparentView(frame: CGRectMake(0,0,Sizing.ScreenWidth(),maxGalleryHeight))
            header.pageView = self.galleryCont
            return header

        }
        else
        {
            if self.mainBarDetailViewCell == nil
            {
                let headerHeight = self.tableView(self.tableView, heightForHeaderInSection: section)
                self.mainBarDetailViewCell = BarDetailViewMainCell.init(frame: CGRectMake(0,0, Sizing.ScreenWidth(), headerHeight))
                self.mainBarDetailViewCell!.Initialize()
            }

            self.mainBarDetailViewCell?.CellWillAppear()
            return self.mainBarDetailViewCell
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
    
    //============================================================================
    //                                  Zoom bar icon when tap
    //============================================================================
    
    func BarIconTapped()
    {
        if barIconButton.tag == 0
        {
            
            barIcon.layer.cornerRadius = 0
            UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.barIcon.frame = CGRectMake(0, 0, Sizing.ScreenWidth(), Sizing.ScreenHeight())
                self.navigationController?.navigationBarHidden = true
                self.tabBarController?.tabBar.hidden = true

            }, completion: nil)
            self.barIconButton.frame = self.barIcon.frame
            
            barIconButton.tag = 1
            
        }
        else
        {            let navBarHeight = self.navigationController!.navigationBar.frame.size.height
            let barIconWidth = self.minGalleryHeight/2
            UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.barIcon.frame = CGRectMake((Sizing.ScreenWidth() - barIconWidth)/2 , (self.minGalleryHeight - barIconWidth)/2 + navBarHeight, barIconWidth,barIconWidth)
                self.barIcon.layer.cornerRadius = barIconWidth/2
                
                self.navigationController?.navigationBarHidden = false
                self.tabBarController?.tabBar.hidden = false
                }, completion: nil)
            


            

            barIconButton.frame = barIcon.frame
            barIconButton.tag = 0
        }
        
    }
    
    //============================================================================
    //                                  scroll mechanics
    //============================================================================
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > 0
        {
            if  scrollView.contentOffset.y < Sizing.HundredRelativeHeightPts()*0.2
            {
                scrollView.setContentOffset(CGPointMake(0,0), animated: true)

            }
            else
            {
                scrollView.setContentOffset(CGPointMake(0,Sizing.HundredRelativeHeightPts()), animated: true)
            }
        }
    }
    

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let y = -scrollView.contentOffset.y;
        if (y>0)
        {
            galleryCont.view.frame = CGRectMake(0, galleryCont.view.frame.origin.y, Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,y +  self.maxGalleryHeight )
            galleryCont.view.center = CGPointMake(self.view.center.x, galleryCont.view.center.y)
            blurrView.frame = CGRectMake(0, galleryCont.view.frame.origin.y, Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,y +  self.maxGalleryHeight )
            blurrView.center = CGPointMake(self.view.center.x, galleryCont.view.center.y)

        }
        
        var x = scrollView.contentOffset.y - Sizing.HundredRelativeHeightPts()
        if(x < 0)
        {
            
            if x < -100
            {
                x = -100
            }
            var offset = (CGFloat(1) - (x/(-Sizing.HundredRelativeHeightPts())))
            if offset > 1
            {
            offset = 0.95
            }
            
            self.blurrView.layer.timeOffset = CFTimeInterval(offset)
            barIcon.alpha = offset
            barIconButton.alpha = offset
        }
    }


    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y;
        if (y>0)
        {
            galleryCont.view.frame = CGRectMake(0, galleryCont.view.frame.origin.y, Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,y +  self.maxGalleryHeight )
            galleryCont.view.center = CGPointMake(self.view.center.x, galleryCont.view.center.y)
            blurrView.frame = CGRectMake(0, galleryCont.view.frame.origin.y, Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,y +  self.maxGalleryHeight )
            blurrView.center = CGPointMake(self.view.center.x, galleryCont.view.center.y)
            
        }
        
        var x = scrollView.contentOffset.y - Sizing.HundredRelativeHeightPts()
        if(x < 0)
        {
            
            if x < -100
            {
                x = -100
            }
            var offset = (CGFloat(1) - (x/(-Sizing.HundredRelativeHeightPts())))
            if offset > 1
            {
                offset = 0.95
            }
            self.blurrView.layer.timeOffset = CFTimeInterval(offset)
            barIcon.alpha = offset
            barIconButton.alpha = offset
        }
    }


    //============================================================================
    //                                 retrieval of data
    //============================================================================
}
