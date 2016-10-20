//
//  BarDetailHeaderView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 18/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailViewMainCell: UITableViewCell {

    var tab1 : UIButton
    var tab2 : UIButton
    var tab3 : UIButton
    var tab4 : UIButton
    var tabHighlighter = UIView()
    var mainDetailView : UIView
    
    var tabCont = UITabBarController()
    var descriptionCont = DescriptionViewController()
    var reviewCont = ReviewsViewController()
    var locationCont = LocationViewController()
    var discountCont = DiscountViewController()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Initialize()
    
    }

    required init?(coder aDecoder: NSCoder) {
        tab1 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab2 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab3 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab4 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        mainDetailView = UIView.init(frame: CGRectMake(0, 0, 0, 0))
        super.init(coder: aDecoder)

    }

    init(frame: CGRect)
    {
        tab1 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab2 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab3 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab4 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        mainDetailView = UIView.init(frame: CGRectMake(0, 0, 0, 0))
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "BarDetailHeaderView")
        self.frame = frame
    }

    func Initialize()
    {
        self.descriptionCont = DescriptionViewController.init(nibName: "DescriptionViewController", bundle: NSBundle.mainBundle())
        
        
        

        let tabWidth = Sizing.ScreenWidth()/4
        let tabHeight = Sizing.HundredRelativeHeightPts()/3
        let mainViewWidth = Sizing.ScreenWidth()
        let mainViewHeight = Sizing.ScreenHeight() - Sizing.HundredRelativeHeightPts()*2/*gallery min height*/ - 49/*tab bar*/
        let mainViewFrame = CGRectMake(0, tabHeight, mainViewWidth, mainViewHeight)
        
        //status bar height?
        tab1 = UIButton.init(frame: CGRectMake(0, 0, tabWidth, tabHeight))
        tab2 = UIButton.init(frame: CGRectMake(tabWidth, 0, tabWidth, tabHeight))
        tab3 = UIButton.init(frame: CGRectMake(Sizing.ScreenWidth() - (tabWidth*2), 0, tabWidth, tabHeight))
        tab4 = UIButton.init(frame: CGRectMake(Sizing.ScreenWidth() - tabWidth, 0, tabWidth, tabHeight))
        mainDetailView = UIView.init(frame: CGRectMake(0, tabHeight, mainViewWidth, mainViewHeight))
        
        tabCont.view.frame = mainViewFrame
        self.descriptionCont.view.frame = mainViewFrame;
        self.reviewCont.view.frame = mainViewFrame;
        self.locationCont.view.frame = mainViewFrame;
        self.discountCont.view.frame = mainViewFrame;
        
        let labelColor = UIColor.blackColor()
        let contentBackgroundColor = UIColor.darkGrayColor()
        self.backgroundColor = UIColor.clearColor()
        tab1.backgroundColor = labelColor
        tab2.backgroundColor = labelColor
        tab3.backgroundColor = labelColor
        tab4.backgroundColor = labelColor
        
        self.tabCont.view.backgroundColor = UIColor.whiteColor()
        descriptionCont.view.backgroundColor = contentBackgroundColor
        reviewCont.view.backgroundColor = contentBackgroundColor
        locationCont.view.backgroundColor = contentBackgroundColor
        discountCont.view.backgroundColor = contentBackgroundColor
        
        mainDetailView.backgroundColor = UIColor.lightGrayColor()
        
//        tab1.titleColorForState(UIControlState.Normal)

        tab1.setTitle("Details", forState: UIControlState.Normal)
        tab2.setTitle("Reviews", forState: UIControlState.Normal)
        tab3.setTitle("Location", forState: UIControlState.Normal)
        tab4.setTitle("Discount", forState: UIControlState.Normal)
        
        
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab3)
        self.addSubview(tab4)
        self.addSubview(tabCont.view)
        
        self.tabCont.addChildViewController(self.descriptionCont)
        self.tabCont.addChildViewController(self.reviewCont)
        self.tabCont.addChildViewController(self.locationCont)
        self.tabCont.addChildViewController(self.discountCont)
        
        
        tab1.addTarget(self, action: "ChangeTab:", forControlEvents: UIControlEvents.TouchUpInside)
        tab2.addTarget(self, action: "ChangeTab:", forControlEvents: UIControlEvents.TouchUpInside)
        tab3.addTarget(self, action: "ChangeTab:", forControlEvents: UIControlEvents.TouchUpInside)
        tab4.addTarget(self, action: "ChangeTab:", forControlEvents: UIControlEvents.TouchUpInside)
        tab1.tag = 0
        tab2.tag = 1
        tab3.tag = 2
        tab4.tag = 3
        
    }
    
    func ChangeTab(sender: AnyObject )
    {
        print(sender.tag)
        tabCont.selectedIndex = sender.tag
    }
    
    func InjectData(bar:Bar)
    {
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
