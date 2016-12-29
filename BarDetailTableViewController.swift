//
//  BarDetailTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 16/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol MainCellDelegate : class{
    func NavCont() -> UINavigationController
}

class BarDetailTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,BarManagerToDetailTableDelegate,ReviewManagerToBarDetailContDelegate,DiscountManagerToDetailTableDelegate,MainCellDelegate {
    
    
    static let singleton = BarDetailTableViewController()
    
    //UI object variables
    var barIcon = UIImageView()
    var barIconButton = UIButton()
    var barTitle = UILabel()
    var barRatingView = RatingStarView()
    var tableView = UITableView()
    var blurrView = UIVisualEffectView()
    var mainBarDetailViewCell:BarDetailViewMainCell?

    
    //view controllers
    var galleryCont = GalleryViewController.singleton
    
    //constants
    let minGalleryHeight = Sizing.minGalleryHeight
    let maxGalleryHeight = Sizing.maxGalleryHeight
    
    var refreshButton : UIBarButtonItem?
    var activityIndicator : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialze()

        
        //blurrView.layer.timeOffset = CFTimeInterval(1)
    }

    
    override func viewWillAppear(_ animated: Bool) {

        
        self.AnimateBlurrView()
        self.UpdateBarIcon()
        self.UpdateBarTitle()
        self.UpdateReviewTab()
        self.UpdateDiscountTab()
        self.UpdateBarRating()
        
        mainBarDetailViewCell?.CellWillAppear()
        galleryCont.ToPresentNewDetailBar()
        

    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        blurrView.layer.timeOffset = CFTimeInterval(1)

        //reset layouts
        self.barIcon.alpha = 1
        self.barTitle.alpha = 1
        let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height);
        self.tableView.setContentOffset(bottomOffset, animated: false)
        
        self.UpdateBarIcon()
        self.UpdateBarTitle()
        self.UpdateReviewTab()
        self.UpdateBarRating()

        
        
        
    }
    func Initialze()
    {
        self.tableView.autoresizesSubviews = false

        //register nibs
        self.tableView.register(UINib(nibName: "BarDetailViewController", bundle: nil), forCellReuseIdentifier: "BarDetailViewController")
        
        //widths and heights
        let barIconWidth = self.minGalleryHeight/2
        let barTitleWidth = Sizing.HundredRelativeWidthPts() * 2
        let barTitleHeight = Sizing.HundredRelativeHeightPts() * 0.3
        let yOffset = -Sizing.HundredRelativeHeightPts()*0.2
        let barRatingHeight = Sizing.HundredRelativeWidthPts()*0.2
        
        //init with frames
        self.tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight() - 49))
        self.barIcon = UIImageView.init(frame: CGRect(x: (Sizing.ScreenWidth() - barIconWidth)/2 , y: (self.minGalleryHeight - barIconWidth)/2 + yOffset, width: barIconWidth,height: barIconWidth))
        self.barIconButton = UIButton.init(frame: CGRect(x: (Sizing.ScreenWidth() - barIconWidth)/2 , y: (self.minGalleryHeight - barIconWidth)/2 + yOffset, width: barIconWidth,height: barIconWidth))
        self.barTitle = UILabel.init(frame: CGRect(x: (Sizing.ScreenWidth() - barTitleWidth)/2, y: self.barIcon.frame.origin.y + barIconWidth + 20 + yOffset, width: barTitleWidth, height: barTitleHeight))
        
        self.barRatingView.SetSizeFromHeight(barRatingHeight)
        self.barRatingView.SetOrigin(CGPoint(x: (Sizing.ScreenWidth()/2 - self.barRatingView.bounds.width/2), y: self.barTitle.frame.origin.y + barTitleHeight ))
        
        
        //set frame first
        self.galleryCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: self.maxGalleryHeight)
        self.galleryCont.Initialize()
        
        //init blurr view
        self.blurrView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.blurrView.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: self.maxGalleryHeight)
        
        //init refresh button
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
        self.activityIndicator?.startAnimating()
        self.refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(BarDetailTableViewController.Refresh))
        self.navigationItem.rightBarButtonItem = self.refreshButton
        
        //colors
        self.view.backgroundColor = ColorManager.detailViewBGColor
        self.tableView.backgroundColor = UIColor.clear
        self.barIcon.backgroundColor = UIColor.black
        self.barTitle.backgroundColor = UIColor.clear
        self.barTitle.textColor = ColorManager.detailBarTitleColor
        self.barIconButton.backgroundColor = UIColor.clear
        self.galleryCont.view.backgroundColor = UIColor.black
        
        //layers
        self.barIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.barIcon.layer.cornerRadius = barIconWidth/2
        self.barIcon.layer.masksToBounds = true
        self.barIconButton.layer.cornerRadius = barIconWidth/2
        self.barIconButton.layer.masksToBounds = true
        self.barRatingView.layer.cornerRadius = barRatingView.bounds.height/2
        self.barRatingView.layer.masksToBounds = true

        
        //fonts
        self.barTitle.textAlignment = .center
        self.barTitle.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        //subviews
        self.addChildViewController(self.galleryCont)
        self.galleryCont.didMove(toParentViewController: self)
        
        self.view.addSubview(self.galleryCont.view)
        self.view.addSubview(self.blurrView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.barTitle)
        self.view.addSubview(self.barRatingView)
        self.view.addSubview(self.barIcon)
        self.view.addSubview(self.barIconButton)
        
        
        //delegates
        BarManager.singleton.detailDelegate = self
        ReviewManager.singleton.delegate = self
        DiscountManager.singleton.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        
        
        //targets
        self.barIconButton.addTarget(self, action: #selector(BarDetailTableViewController.BarIconTapped), for: UIControlEvents.touchUpInside)
        
        //0 means not zoomed in
        self.barIconButton.tag = 0
        
        
        
        
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
        self.UpdateBarRating()
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

        self.title = BarManager.singleton.displayedDetailBar.name
        self.barTitle.text = BarManager.singleton.displayedDetailBar.name
        })
    }
    func UpdateGallery()
    {
        
    }
    
    func UpdateBarRating()
    {
        DispatchQueue.main.async(execute: {
            self.barRatingView.SetRating(BarManager.singleton.displayedDetailBar.rating.avg)
        })
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
                self.mainBarDetailViewCell?.reviewCont.ReloadReviewTableData()
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
                
                //must set delegate first because initialize uses the delegate to get navigation controller (nav bar height)
                self.mainBarDetailViewCell?.delegate = self
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
        {
            
            let yOffset = -Sizing.HundredRelativeHeightPts()*0.2

            let barIconWidth = self.minGalleryHeight/2
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                self.barIcon.frame = CGRect(x: (Sizing.ScreenWidth() - barIconWidth)/2 , y: (self.minGalleryHeight - barIconWidth)/2 + yOffset, width: barIconWidth,height: barIconWidth)
                

                self.barIcon.layer.cornerRadius = barIconWidth/2
                
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.isHidden = false
                }, completion: nil)
            


            

            barIconButton.frame = barIcon.frame
            barIconButton.tag = 0
        }
        
    }
    

    func Refresh()
    {
        //refresh button -> spinner
        DispatchQueue.main.async(execute: {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
        })
        
        
        //load generic details -> load reviews and discounts -> gallery image
        BarManager.singleton.ReloadBar(ID: BarManager.singleton.displayedDetailBar.ID,handler: {
            (success,error,bar) -> Void in
            
            if success
            {
                //update current bar info
                let thisBar = BarManager.singleton.displayedDetailBar
                thisBar.name = bar.name
                thisBar.icon = bar.icon
                thisBar.bookingAvailable = bar.bookingAvailable
                thisBar.contact = bar.contact
                thisBar.description = bar.description
                thisBar.loc_lat  = bar.loc_lat
                thisBar.loc_long = bar.loc_long
                thisBar.rating = bar.rating
                thisBar.website = bar.website // not done
                thisBar.openClosingHours = bar.openClosingHours
                
                //update displays
                self.UpdateBarIcon()
                self.UpdateBarTitle()
                self.UpdateDescriptionTab()
                self.UpdateBarRating()
            }
            else
            {
                PopupManager.singleton.Popup(title: "Error", body: error, presentationViewCont: self)
            }
            
            //spinner -> refresh button
            DispatchQueue.main.async(execute: {
                self.navigationItem.rightBarButtonItem = self.refreshButton
            })
        })
    }
    
    //============================================================================
    //                                  scroll mechanics
    //============================================================================
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //snap detail view
        if scrollView.contentOffset.y > 0
        {
            if  scrollView.contentOffset.y < Sizing.HundredRelativeHeightPts()*0.2
            {
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)

            }
            else
            {
                scrollView.setContentOffset(CGPoint(x: 0,y: maxGalleryHeight - minGalleryHeight), animated: true)
            }
        }
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        UpdateScrollFrames(scrollView)
        UpdateScrollAlphas(scrollView)
       
    }


    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UpdateScrollFrames(scrollView)
        UpdateScrollAlphas(scrollView)
    }

    func UpdateScrollFrames(_ scrollView: UIScrollView)
    {
        let y = -scrollView.contentOffset.y;
        if (y>0)
        {
            
            galleryCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(),height: y +  self.maxGalleryHeight )
            
            galleryCont.view.center = CGPoint(x: self.view.center.x, y: galleryCont.view.center.y)
            
            galleryCont.UpdateFrameDuringScroll()
            
            blurrView.frame = CGRect(x: 0, y: galleryCont.view.frame.origin.y, width: Sizing.ScreenWidth()+y*Sizing.ScreenWidth()/330,height: y +  self.maxGalleryHeight )
            blurrView.center = CGPoint(x: self.view.center.x, y: galleryCont.view.center.y)
            
        }
    }
    
    func UpdateScrollAlphas(_ scrollView: UIScrollView)
    {
        let x = scrollView.contentOffset.y - (maxGalleryHeight - minGalleryHeight)
        if(x < 0)
        {
            
            
            let offset = (1 - (x/(-(maxGalleryHeight - minGalleryHeight))))
            

            
            SetBlurrAmount(amount: offset)
            barIcon.alpha = offset
            barIconButton.alpha = offset
            barTitle.alpha = offset
            barRatingView.alpha = offset
        }
    }

    func AnimateBlurrView()
    {
        blurrView.layer.speed = 0
        blurrView.effect = nil

        
        UIView.animate(withDuration: 1, animations: {
            
            self.blurrView.effect = UIBlurEffect(style: .light)

        }, completion: {
            (success) -> Void in
            
            self.blurrView.effect = nil
        
        })
        
        blurrView.layer.timeOffset = CFTimeInterval(0)


        
        
        self.blurrView.layer.repeatCount = 1e100


    }

    func SetBlurrAmount(amount : CGFloat)
    {

        var offset = amount
        if amount < 0
        {
            offset = 0
        }
        
        
        
        blurrView.layer.timeOffset = CFTimeInterval(offset)
        
        
    }
    //============================================================================
    //                                 delegate functions
    //============================================================================

    func NavCont() -> UINavigationController
    {
        return self.navigationController!
    }
}
