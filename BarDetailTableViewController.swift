//
//  BarDetailTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 16/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,BarManagerToDetailTableDelegate,ReviewManagerToBarDetailContDelegate,DiscountManagerToDetailTableDelegate {
    static let singleton = BarDetailTableViewController()
    
    //UI object variables
    var barIcon = UIImageView()
    var barIconButton = UIButton()
    var barTitle = UILabel()
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

    
    override func viewWillAppear(_ animated: Bool) {
        

        self.UpdateBarIcon()
        self.UpdateBarTitle()
        self.UpdateReviewTab()
        self.UpdateDiscountTab()
        
        
        mainBarDetailViewCell?.CellWillAppear()
        galleryCont.ToPresentNewDetailBar()


    }

    override func viewDidAppear(_ animated: Bool) {
        //reset layouts
        self.barIcon.alpha = 1
        self.barTitle.alpha = 1
        let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height);
        self.tableView.setContentOffset(bottomOffset, animated: false)
        
        self.UpdateBarIcon()
        self.UpdateBarTitle()
        self.UpdateReviewTab()
        
        self.blurrView.effect = nil
        
        UIView.animate(withDuration: 1.0, animations: {
            self.blurrView.effect = UIBlurEffect(style: .light)
        })
    }
    func Initialze()
    {

        DispatchQueue.main.async(execute: {
            //register nibs
            self.tableView.register(UINib(nibName: "BarDetailViewController", bundle: nil), forCellReuseIdentifier: "BarDetailViewController")
            
          
            //initialize controllers

            
            
            
            //build layout
            let navBarHeight : CGFloat = 0
            let barIconWidth = self.minGalleryHeight/2
            let barTitleWidth = Sizing.HundredRelativeWidthPts() * 2
            let barTitleHeight = Sizing.HundredRelativeHeightPts() * 0.3
            let yOffset = -Sizing.HundredRelativeHeightPts()*0.1
            self.tableView = UITableView.init(frame: CGRect(x: 0, y: navBarHeight, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight() - navBarHeight - 49))
            self.barIcon = UIImageView.init(frame: CGRect(x: (Sizing.ScreenWidth() - barIconWidth)/2 , y: (self.minGalleryHeight - barIconWidth)/2 + navBarHeight + yOffset, width: barIconWidth,height: barIconWidth))
            self.barIconButton = UIButton.init(frame: CGRect(x: (Sizing.ScreenWidth() - barIconWidth)/2 , y: (self.minGalleryHeight - barIconWidth)/2 + navBarHeight + yOffset, width: barIconWidth,height: barIconWidth))
            self.barTitle = UILabel.init(frame: CGRect(x: (Sizing.ScreenWidth() - barTitleWidth)/2, y: self.barIcon.frame.origin.y + barIconWidth + 20 + yOffset, width: barTitleWidth, height: barTitleHeight))

            
            //must set frame first
            self.galleryCont.view.frame = CGRect(x: 0, y: navBarHeight, width: Sizing.ScreenWidth(), height: self.maxGalleryHeight)
            self.galleryCont.Initialize()
            
            //self.blurrView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            self.blurrView = UIVisualEffectView(effect: nil)
            self.blurrView.frame = CGRect(x: 0, y: navBarHeight, width: Sizing.ScreenWidth(), height: self.maxGalleryHeight)
            self.blurrView.layer.speed = 0

            self.view.backgroundColor = ColorManager.detailViewBGColor
            self.tableView.backgroundColor = ColorManager.detailViewBGColor
            self.barIcon.backgroundColor = UIColor.black
            self.barTitle.backgroundColor = UIColor.clear
            self.barTitle.textColor = ColorManager.detailBarTitleColor
            self.barIconButton.backgroundColor = UIColor.clear
            self.galleryCont.view.backgroundColor = ColorManager.galleryBGColor
            
            self.barIcon.contentMode = UIViewContentMode.scaleAspectFit
            self.barIcon.layer.cornerRadius = barIconWidth/2
            self.barIcon.layer.masksToBounds = true
            self.barIconButton.layer.cornerRadius = barIconWidth/2
            self.barIconButton.layer.masksToBounds = true
            
            
            self.barTitle.textAlignment = .center
            self.barTitle.font = UIFont.boldSystemFont(ofSize: 22.0)
            
            self.view.addSubview((self.galleryCont.view))
            self.view.addSubview(self.blurrView)

            self.view.addSubview(self.tableView)
            self.view.addSubview(self.barIcon)
            self.view.addSubview(self.barIconButton)
            self.view.addSubview(self.barTitle)
            
            self.addChildViewController(self.galleryCont)
            self.galleryCont.didMove(toParentViewController: self)
            
            BarManager.singleton.detailDelegate = self
            ReviewManager.singleton.delegate = self
            DiscountManager.singleton.delegate = self
            self.tableView.dataSource = self
            self.tableView.delegate = self
        

            self.barIconButton.addTarget(self, action: #selector(BarDetailTableViewController.BarIconTapped), for: UIControlEvents.touchUpInside)
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
        self.UpdateBarTitle()
    }
    
    func UpdateBarIcon()
    {
        DispatchQueue.main.async(execute: {
        self.barIcon.image = BarManager.singleton.displayedDetailBar.icon

        })
    }
    func UpdateBarTitle()
    {
        DispatchQueue.main.async(execute: {

        self.barTitle.text = BarManager.singleton.displayedDetailBar.name
        })
    }
    func UpdateGallery()
    {
        
    }
    
    func UpdateTabs()
    {
        UpdateDescriptionTab()
        UpdateReviewTab()
        UpdateDiscountTab()
    }
    
    func UpdateDescriptionTab()
    {
        //update bar description tab
        DispatchQueue.main.async(execute: {
        self.mainBarDetailViewCell?.descriptionCont.tableView?.reloadData()
        })
    }
    
    func UpdateReviewTab()
    {
        DispatchQueue.main.async(execute: {
                self.mainBarDetailViewCell?.reviewCont.tableView.reloadData()
            })

    }
    
    func UpdateDiscountTab()
    {
        DispatchQueue.main.async(execute: {
            self.mainBarDetailViewCell?.discountCont.tableView?.reloadData()
        })
    }
    
    // MARK: - Table view data source

    //============================================================================
    //                                 number of rows and sections
    //============================================================================
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

	//===============================================================================
	//									gallery and main detail view (CELLS)
	//===============================================================================
   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {			
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        cell!.backgroundColor = UIColor.clear
        
        


        return cell!
    }
    
    //===============================================================================
    //											Height of Cells
    //===============================================================================
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        return 0
    }
    
    //============================================================================
    //                                  Main Display (Headers)
    //============================================================================
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            let header = TransparentView(frame: CGRect(x: 0,y: 0,width: Sizing.ScreenWidth(),height: maxGalleryHeight))
            header.pageView = self.galleryCont
            return header

        }
        else
        {
            if self.mainBarDetailViewCell == nil
            {
                let headerHeight = self.tableView(self.tableView, heightForHeaderInSection: section)
                self.mainBarDetailViewCell = BarDetailViewMainCell.init(frame: CGRect(x: 0,y: 0, width: Sizing.ScreenWidth(), height: headerHeight))
                self.mainBarDetailViewCell!.Initialize()
            }

            self.mainBarDetailViewCell?.CellWillAppear()
            return self.mainBarDetailViewCell
        }
    }
    //============================================================================
    //                                  section header height
    //============================================================================
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            //height of gallery
            return maxGalleryHeight
        }
        let screenHeight = Sizing.ScreenHeight()

        return (screenHeight - 49/*tab bar height */ - minGalleryHeight) /*screen height - nav bar height - tab bar height - min gallery height*/
    }
    
    //============================================================================
    //                                  Zoom bar icon when tap
    //============================================================================
    
    func BarIconTapped()
    {
        if barIconButton.tag == 0
        {
            
            barIcon.layer.cornerRadius = 0
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                self.barIcon.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight())
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true

            }, completion: nil)
            self.barIconButton.frame = self.barIcon.frame
            
            barIconButton.tag = 1
            
        }
        else
        {            let navBarHeight : CGFloat = 0
            let barIconWidth = self.minGalleryHeight/2
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                self.barIcon.frame = CGRect(x: (Sizing.ScreenWidth() - barIconWidth)/2 , y: (self.minGalleryHeight - barIconWidth)/2 + navBarHeight, width: barIconWidth,height: barIconWidth)
                self.barIcon.layer.cornerRadius = barIconWidth/2
                
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.isHidden = false
                }, completion: nil)
            


            

            barIconButton.frame = barIcon.frame
            barIconButton.tag = 0
        }
        
    }
    

    
    
    //============================================================================
    //                                  scroll mechanics
    //============================================================================
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > 0
        {
            if  scrollView.contentOffset.y < Sizing.HundredRelativeHeightPts()*0.2
            {
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)

            }
            else
            {
                scrollView.setContentOffset(CGPoint(x: 0,y: Sizing.HundredRelativeHeightPts()), animated: true)
            }
        }
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = -scrollView.contentOffset.y;
        if (y>0)
        {
            galleryCont.view.frame = CGRect(x: 0, y: galleryCont.view.frame.origin.y, width: Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,height: y +  self.maxGalleryHeight )
            galleryCont.view.center = CGPoint(x: self.view.center.x, y: galleryCont.view.center.y)
            blurrView.frame = CGRect(x: 0, y: galleryCont.view.frame.origin.y, width: Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,height: y +  self.maxGalleryHeight )
            blurrView.center = CGPoint(x: self.view.center.x, y: galleryCont.view.center.y)

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
            barTitle.alpha = offset
        }
    }


    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y;
        if (y>0)
        {
            galleryCont.view.frame = CGRect(x: 0, y: galleryCont.view.frame.origin.y, width: Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,height: y +  self.maxGalleryHeight )
            galleryCont.view.center = CGPoint(x: self.view.center.x, y: galleryCont.view.center.y)
            blurrView.frame = CGRect(x: 0, y: galleryCont.view.frame.origin.y, width: Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,height: y +  self.maxGalleryHeight )
            blurrView.center = CGPoint(x: self.view.center.x, y: galleryCont.view.center.y)
            
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
            barTitle.alpha = offset
        }
    }


    //============================================================================
    //                                 retrieval of data
    //============================================================================
}
