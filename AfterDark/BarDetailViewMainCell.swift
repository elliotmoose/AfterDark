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

    var tab1 : UIButton
    var tab2 : UIButton
    var tab3 : UIButton
    var tab4 : UIButton
    var tabHighlighter: UIView
    
    var tabCont = UITabBarController()
    var descriptionCont = DescriptionViewController()
    var reviewCont = ReviewsViewController()
    var locationCont = LocationViewController()
    var discountCont = DiscountViewController()
    
    var delegate : MainCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Initialize()
    
    }

    func CellWillAppear()
    {
        ChangeTab(tab1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tab1 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab2 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab3 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab4 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tabHighlighter = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(coder: aDecoder)

    }

    init(frame: CGRect)
    {
        tab1 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab2 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab3 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab4 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tabHighlighter = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "BarDetailHeaderView")
        self.frame = frame
    }

    func Initialize()
    {

        //init tabs
        self.descriptionCont = DescriptionViewController.init(nibName: nil, bundle: nil)
        self.descriptionCont.view = UIView(frame: .zero)
        self.descriptionCont.Initialize()
        
        self.reviewCont.Initialize()
        

        //sizing
        let tabWidth = Sizing.ScreenWidth()/4
        let tabHeight = Sizing.tabHeight
        let mainViewWidth = Sizing.ScreenWidth()
        let mainViewHeight = Sizing.mainViewHeight
        
        let tabContFrame = CGRect(x: 0, y: tabHeight, width: mainViewWidth, height: mainViewHeight + Sizing.statusBarHeight)
        let detailViewFrame = CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight - tabHeight)
        let highlighterHeight: CGFloat = 4.5
        //status bar height?
        
        //initialize and frame
        tabHighlighter = UIView.init(frame: CGRect(x: 0, y: tabHeight - highlighterHeight, width: tabWidth, height: highlighterHeight))
        tab1 = UIButton.init(frame: CGRect(x: 0, y: 0, width: tabWidth, height: tabHeight))
        tab2 = UIButton.init(frame: CGRect(x: tabWidth, y: 0, width: tabWidth, height: tabHeight))
        tab3 = UIButton.init(frame: CGRect(x: Sizing.ScreenWidth() - (tabWidth*2), y: 0, width: tabWidth, height: tabHeight))
        tab4 = UIButton.init(frame: CGRect(x: Sizing.ScreenWidth() - tabWidth, y: 0, width: tabWidth, height: tabHeight))
        
        //frames
        tabCont.view.frame = tabContFrame
        self.descriptionCont.view.frame = detailViewFrame;
        self.descriptionCont.tableView?.frame = detailViewFrame
        self.reviewCont.view.frame = detailViewFrame;
        self.reviewCont.tableView.frame = detailViewFrame
        self.locationCont.view.frame = detailViewFrame;
        self.discountCont.view.frame = detailViewFrame;
        self.discountCont.tableView?.frame = detailViewFrame
        
        //colors
        let labelColor = ColorManager.detailTabBGColor
        let contentBackgroundColor = ColorManager.descriptionBGColor
        let tabSelectColor = ColorManager.detailTabHighlightedColor
        let tabDeselectColor = ColorManager.detailTabDeselectedColor
        
        self.backgroundColor = UIColor.clear
        tab1.backgroundColor = labelColor
        tab2.backgroundColor = labelColor
        tab3.backgroundColor = labelColor
        tab4.backgroundColor = labelColor
        
        tab1.setTitleColor(tabDeselectColor, for: UIControlState())
        tab2.setTitleColor(tabDeselectColor, for: UIControlState())
        tab3.setTitleColor(tabDeselectColor, for: UIControlState())
        tab4.setTitleColor(tabDeselectColor, for: UIControlState())
        
        tab1.setTitleColor(tabSelectColor, for: UIControlState.selected)
        tab2.setTitleColor(tabSelectColor, for: UIControlState.selected)
        tab3.setTitleColor(tabSelectColor, for: UIControlState.selected)
        tab4.setTitleColor(tabSelectColor, for: UIControlState.selected)
        
        tabHighlighter.backgroundColor = tabSelectColor
        self.tabCont.view.backgroundColor = UIColor.white
        descriptionCont.view.backgroundColor = contentBackgroundColor
        reviewCont.view.backgroundColor = contentBackgroundColor
        locationCont.view.backgroundColor = contentBackgroundColor
        discountCont.view.backgroundColor = contentBackgroundColor
        
        //tab titles
        tab1.setTitle("Details", for: UIControlState())
        tab2.setTitle("Discount", for: UIControlState())
        tab3.setTitle("Reviews", for: UIControlState())
        tab4.setTitle("Location", for: UIControlState())
        
        //subviews
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab3)
        self.addSubview(tab4)
        self.addSubview(tabCont.view)
        self.addSubview(tabHighlighter)
        self.tabCont.addChildViewController(self.descriptionCont)
        self.tabCont.addChildViewController(self.discountCont)
        self.tabCont.addChildViewController(self.reviewCont)
        self.tabCont.addChildViewController(self.locationCont)
        
        //actions and events
        tab1.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
        tab2.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
        tab3.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
        tab4.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
        
        //label tags
        tab1.tag = 0
        tab2.tag = 1
        tab3.tag = 2
        tab4.tag = 3
        
        //turn resizing off
        self.autoresizesSubviews = false
        self.reviewCont.tableView.autoresizesSubviews = false
        
        //delegate
        reviewCont.delegate = self
        
        
        //shadows
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: -3)
        self.clipsToBounds = false
        
        tab1.layer.shadowOpacity = 0.4
        tab1.layer.shadowOffset = CGSize(width: 0, height: 2)
        tab1.layer.shadowRadius = 2
        tab1.clipsToBounds = false
        
        tab2.layer.shadowOpacity = 0.4
        tab2.layer.shadowOffset = CGSize(width: 0, height: 2)
        tab2.layer.shadowRadius = 2
        tab2.clipsToBounds = false
        
        tab3.layer.shadowOpacity = 0.4
        tab3.layer.shadowOffset = CGSize(width: 0, height: 2)
        tab3.layer.shadowRadius = 2
        tab3.clipsToBounds = false
        
        tab4.layer.shadowOpacity = 0.4
        tab4.layer.shadowOffset = CGSize(width: 0, height: 2)
        tab4.layer.shadowRadius = 2
        tab4.clipsToBounds = false
        
        self.bringSubview(toFront: tab1)
        self.bringSubview(toFront: tab2)
        self.bringSubview(toFront: tab3)
        self.bringSubview(toFront: tab4)
        self.bringSubview(toFront: tabHighlighter)

    }
    
    func ChangeTab(_ sender: AnyObject )
    {
        tabCont.selectedIndex = sender.tag
        let button = sender as! UIButton
        button.isSelected = true
        
        //select button, deselect others
        switch sender.tag
        {
        case 0:
            tab2.isSelected = false;
            tab3.isSelected = false;
            tab4.isSelected = false;
        case 1:
            tab1.isSelected = false;
            tab3.isSelected = false;
            tab4.isSelected = false;
            
        case 2:
            tab1.isSelected = false;
            tab2.isSelected = false;
            tab4.isSelected = false;
            
        case 3:
            tab1.isSelected = false;
            tab2.isSelected = false;
            tab3.isSelected = false;
        default:
            
            break
        }
        
        MoveHighlight(sender.tag)
    }
    
    func MoveHighlight(_ index:Int)
    {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: UIViewAnimationOptions(), animations: {
            self.tabHighlighter.frame = CGRect( x: self.tabHighlighter.frame.size.width * CGFloat(index),  y: self.tabHighlighter.frame.origin.y,  width: self.tabHighlighter.frame.size.width,  height: self.tabHighlighter.frame.size.height)
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
