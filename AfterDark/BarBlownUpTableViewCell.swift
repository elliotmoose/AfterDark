//
//  BarBlownUpTableViewCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class BarBlownUpTableViewCell: UITableViewCell,TabDelegate ,DiscountToMainCellDelegate{

    
    var tabCont = UITabBarController()
    var detailsCont = DetailsViewController()
    var reviewCont = ReviewViewController(nibName: "ReviewViewController", bundle: Bundle.main)
    var discountCont = DiscountViewController()
    var descriptionCont = DescriptionViewController()
    var galleryCont = GalleryViewController()

    
    var tabs = [UIButton]()
    
    
    var delegate : MainCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()

        Initialize()
    
    }

    
    func CellWillAppear()
    {
        
        galleryCont.ToPresentNewDetailBar()
        self.galleryCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight)
        
        reviewCont.LoadCanGiveReview()
        
        //ensure there are tabs
        guard tabs.count > 0 else {return}
        ChangeTab(tabs[0])
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Initialize()
    {
        //self
        self.selectionStyle = .none
        
        //init tabs
        self.detailsCont = DetailsViewController.init(nibName: nil, bundle: nil)
        self.detailsCont.view = UIView(frame: .zero)
        self.detailsCont.Initialize()
        
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
            newTab.addTarget(self, action: #selector(self.ChangeTab(_:)), for: UIControlEvents.touchUpInside)
            newTab.titleLabel?.font = UIFont(name: "Mohave-Bold", size: 16.5)
            
            
            switch index {
            case 0:
                newTab.setTitle("Details", for: .normal)
            case 1:
                newTab.setTitle("Discount", for: .normal)
            case 2:
                newTab.setTitle("Reviews", for: .normal)
            case 3:
                newTab.setTitle("About Us", for: .normal)
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
        let tabContFrame = CGRect(x: 0, y: tabHeight + Sizing.galleryHeight, width: Sizing.ScreenWidth()*2, height: Sizing.mainViewHeightWithTabs)
        let detailViewFrame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.mainViewHeight - tabHeight - Sizing.galleryHeight)

        //frames

        self.detailsCont.view.frame = detailViewFrame;
        self.detailsCont.tableView?.frame = detailViewFrame
        self.discountCont.view.frame = detailViewFrame;
        self.discountCont.tableView?.frame = detailViewFrame
        self.descriptionCont.view.frame = detailViewFrame
        
        //delegates
        //reviewCont.delegate = self
        discountCont.delegate = self
        
        //shadows
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: -3)
        self.clipsToBounds = false
    
        
        self.addSubview(tabCont.view)
        self.tabCont.addChildViewController(self.detailsCont)
        self.tabCont.addChildViewController(self.discountCont)
        self.tabCont.addChildViewController(self.reviewCont)
        self.tabCont.addChildViewController(self.descriptionCont)
        tabCont.view.frame = tabContFrame
        tabCont.viewDidLayoutSubviews()
        tabCont.view.layoutSubviews()
        
        
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
    
    func PushViewController(viewCont: UIViewController) {
        self.delegate?.NavCont().pushViewController(viewCont, animated: true)
    }

}
