//
//  BarBlownUpTableViewCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class BarBlownUpTableViewCell: UITableViewCell,TabDelegate {

    
    var tabCont = UITabBarController()
    var descriptionCont = DescriptionViewController()
    var reviewCont = ReviewsViewController()
    var discountCont = DiscountViewController()
    var galleryCont = GalleryViewController.singleton

    
    var tabs = [UIButton]()
    
    
    var delegate : MainCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()

        Initialize()
    
    }

    func CellWillAppear()
    {
        galleryCont.ToPresentNewDetailBar()
        guard tabs.count > 0 else {return}
        ChangeTab(tabs[0])
        
        self.galleryCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Initialize()
    {
        
        //init tabs
        self.descriptionCont = DescriptionViewController.init(nibName: nil, bundle: nil)
        self.descriptionCont.view = UIView(frame: .zero)
        self.descriptionCont.Initialize()
        self.reviewCont.Initialize()
        
        //sizing
        let tabHeight = Sizing.tabHeight
        let numberOfTabs = 4
        let tabWidth = Sizing.ScreenWidth()/CGFloat(numberOfTabs)
        
        tabs.removeAll()
        
        //tabs
        for index in 0...numberOfTabs-1
        {
            let newTab = UIButton(frame: CGRect(x: tabWidth * CGFloat(index), y: Sizing.galleryHeight, width: tabWidth, height: tabHeight))
            newTab.tag = index
            
            //colors
            newTab.backgroundColor = UIColor.black
            newTab.setTitleColor(UIColor.white, for: .normal)
            newTab.backgroundColor = ColorManager.themeDull
            newTab.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
            newTab.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 13)
            
            
            switch index {
            case 0:
                newTab.setTitle("Details", for: .normal)
            case 1:
                newTab.setTitle("Discount", for: .normal)
            case 2:
                newTab.setTitle("Reviews", for: .normal)
            case 3:
                newTab.setTitle("Gallery", for: .normal)
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
        
        //init view controllers
        let tabContFrame = CGRect(x: 0, y: tabHeight + Sizing.galleryHeight, width: Sizing.ScreenWidth(), height: Sizing.mainViewHeightWithTabs)
        let detailViewFrame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.mainViewHeight - tabHeight - Sizing.galleryHeight)

        //frames
        tabCont.view.frame = tabContFrame
        self.descriptionCont.view.frame = detailViewFrame;
        self.descriptionCont.tableView?.frame = detailViewFrame
        self.reviewCont.view.frame = detailViewFrame;
        self.reviewCont.tableView?.frame = detailViewFrame
        self.discountCont.view.frame = detailViewFrame;
        self.discountCont.tableView?.frame = detailViewFrame
        
        //delegate
        reviewCont.delegate = self
        
        
        //shadows
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: -3)
        self.clipsToBounds = false
    
        
        self.addSubview(tabCont.view)
        self.tabCont.addChildViewController(self.descriptionCont)
        self.tabCont.addChildViewController(self.discountCont)
        self.tabCont.addChildViewController(self.reviewCont)
        
        
        //gallery
        self.galleryCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight)
        self.galleryCont.Initialize(frame : CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight))
        self.addSubview(galleryCont.view)
        self.galleryCont.view.backgroundColor = UIColor.black

        
        //arrange sub views
        for tab in tabs
        {
            self.bringSubview(toFront: tab)
        }
        
        
    }
    

    
    
    func ChangeTab(_ sender: AnyObject )
    {
        let index = sender.tag
        tabCont.selectedIndex = index!
        let button = sender as! UIButton
        button.isSelected = true
        
        
        for tab in tabs
        {
            if tab.tag != sender.tag
            {
                tab.isSelected = false
                tab.backgroundColor = ColorManager.themeDull
            }
            
        }
        
        button.backgroundColor = ColorManager.themeBright
        self.bringSubview(toFront: button)
        
    }
    

    func NavCont() -> UINavigationController {
        return (self.delegate?.NavCont())!
    }

}
