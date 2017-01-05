//
//  BarDetailHeaderView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 18/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol TabDelegate : class {
    func NavCont() -> UINavigationController
}

class BarDetailViewMainCell: UITableViewCell, TabDelegate {

    var tabs = [UIButton]()

    var tabHighlighter: UIView?
    
    var tabCont = UITabBarController()
    var detailsCont = DetailsViewController()
    var reviewCont = ReviewsViewController()
    var locationCont = LocationViewController()
    var discountCont = DiscountViewController()
    
    var delegate : MainCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Initialize()
    
    }

    
    required init?(coder aDecoder: NSCoder) {
//        tab1 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tab2 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tab3 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tab4 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tabHighlighter = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(coder: aDecoder)

    }

    init(frame: CGRect)
    {
//        tab1 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tab2 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tab3 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tab4 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tabHighlighter = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "BarDetailHeaderView")
        self.frame = frame
    }

    func Initialize()
    {

        //init tabs
        self.detailsCont = DetailsViewController.init(nibName: nil, bundle: nil)
        self.detailsCont.view = UIView(frame: .zero)
        self.detailsCont.Initialize()
        
        self.reviewCont.Initialize()
        

        //sizing
        let tabHeight = Sizing.tabHeight
        let mainViewWidth = Sizing.ScreenWidth()
        let mainViewHeight = Sizing.mainViewHeight
        let numberOfTabs = 4
        let tabWidth = Sizing.ScreenWidth()/CGFloat(numberOfTabs)
        
        let tabContFrame = CGRect(x: 0, y: tabHeight, width: mainViewWidth, height: mainViewHeight + Sizing.statusBarHeight)
        let detailViewFrame = CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight - tabHeight)
        let highlighterHeight: CGFloat = 4.5
        //status bar height?
        
        //initialize and frame
        tabHighlighter = UIView.init(frame: CGRect(x: 0, y: tabHeight - highlighterHeight, width: tabWidth, height: highlighterHeight))

        guard let tabHighlighter = tabHighlighter else {return}
        
        
        //init tab buttons

        for index in 0...numberOfTabs-1
        {
            let newTab = UIButton(frame: CGRect(x: tabWidth * CGFloat(index), y: 0, width: tabWidth, height: tabHeight))
            newTab.tag = index
            
            //colors
            newTab.backgroundColor = UIColor.black
            newTab.setTitleColor(ColorManager.themeGray, for: .normal)
            newTab.setTitleColor(ColorManager.themeBright, for: .selected)
            
            newTab.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
            
            switch index {
            case 0:
                newTab.setTitle("Details", for: .normal)
            case 1:
                newTab.setTitle("Discount", for: .normal)
            case 2:
                newTab.setTitle("Reviews", for: .normal)
            case 3:
                newTab.setTitle("Location", for: .normal)
            default:
                break
            }
            
            newTab.layer.shadowOpacity = 0.4
            newTab.layer.shadowOffset = CGSize(width: 0, height: 2)
            newTab.layer.shadowRadius = 2
            newTab.clipsToBounds = false
            
            tabs.append(newTab)
            
            self.addSubview(newTab)
            
        }
        
        
        //frames
        tabCont.view.frame = tabContFrame
        self.detailsCont.view.frame = detailViewFrame;
        self.detailsCont.tableView?.frame = detailViewFrame
        self.reviewCont.view.frame = detailViewFrame;
        self.reviewCont.tableView?.frame = detailViewFrame
        self.locationCont.view.frame = detailViewFrame;
        self.discountCont.view.frame = detailViewFrame;
        self.discountCont.tableView?.frame = detailViewFrame
        
        //colors
        let labelColor = ColorManager.detailTabBGColor
        let contentBackgroundColor = ColorManager.descriptionBGColor
        let tabSelectColor = ColorManager.detailTabHighlightedColor
        let tabDeselectColor = ColorManager.detailTabDeselectedColor
        
        self.backgroundColor = UIColor.clear

        
        tabHighlighter.backgroundColor = tabSelectColor
        self.tabCont.view.backgroundColor = UIColor.white
        detailsCont.view.backgroundColor = contentBackgroundColor
        reviewCont.view.backgroundColor = contentBackgroundColor
        locationCont.view.backgroundColor = contentBackgroundColor
        discountCont.view.backgroundColor = contentBackgroundColor
        
        
        //subviews

        self.addSubview(tabCont.view)
        self.addSubview(tabHighlighter)
        self.tabCont.addChildViewController(self.detailsCont)
        self.tabCont.addChildViewController(self.discountCont)
        self.tabCont.addChildViewController(self.reviewCont)
        self.tabCont.addChildViewController(self.locationCont)
        

        //turn resizing off
        self.autoresizesSubviews = false
        self.reviewCont.tableView?.autoresizesSubviews = false
        
        //delegate
        reviewCont.delegate = self
        
        
        //shadows
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: -3)
        self.clipsToBounds = false

        
        for tab in tabs
        {
            self.bringSubview(toFront: tab)
        }
        

        self.bringSubview(toFront: tabHighlighter)

    }
    
    func ChangeTab(_ sender: AnyObject )
    {
        tabCont.selectedIndex = sender.tag
        let button = sender as! UIButton
        button.isSelected = true

        
        for tab in tabs
        {
            if tab.tag != sender.tag
            {
                tab.isSelected = false
            }
            
        }
        
        MoveHighlight(sender.tag)
    }
    
    func MoveHighlight(_ index:Int)
    {
        guard let _ = tabHighlighter else {return}

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: UIViewAnimationOptions(), animations: {


            self.tabHighlighter!.frame = CGRect( x: self.tabHighlighter!.frame.size.width * CGFloat(index),  y: self.tabHighlighter!.frame.origin.y,  width: self.tabHighlighter!.frame.size.width,  height: self.tabHighlighter!.frame.size.height)
            }, completion: nil)
    }
    func InjectData(_ bar:Bar)
    {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func NavCont() -> UINavigationController {
        return (self.delegate?.NavCont())!
    }
    
}
