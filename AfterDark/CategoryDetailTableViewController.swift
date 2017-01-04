//
//  CategoryDetailTableViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainCellDelegate {
    
    //constants
    let tabHeight : CGFloat = Sizing.catTabHeight
    let highlighterHeight : CGFloat = 10
    let locationViewHeight = Sizing.ScreenHeight()/4

    
    //objects
    var tableView : UITableView?
    
    var displayedBarIDs = [String]()
    
    let locationCont = LocationViewController()
    
    var tabs = [UIButton]()
    
    var tabHighlighter: UIImageView?
    
    var viewState = 1 //0 = no maps 1 = maps and bar list 2 = full maps..?
    
    var barBlownUpCell : BarBlownUpTableViewCell?
    //runtime object variables
    //var barBlownUp : Bar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //init location view
        locationCont.view.backgroundColor = UIColor.blue
        locationCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: locationViewHeight)
        self.addChildViewController(locationCont)
        self.view.addSubview(locationCont.view)
        
        //init tab buttons

        let numberOfTabs = 3
        let tabWidth = Sizing.ScreenWidth()/CGFloat(numberOfTabs)
        for index in 0...numberOfTabs-1
        {
            //init
            let newTab = UIButton(frame: CGRect(x: tabWidth * CGFloat(index), y: locationViewHeight, width: tabWidth, height: tabHeight))
            newTab.tag = index
            
            //colors
            newTab.backgroundColor = UIColor.black
            newTab.setTitleColor(ColorManager.themeGray, for: .normal)
            newTab.setTitleColor(ColorManager.themeBright, for: .selected)
            
            //control
            newTab.addTarget(self, action: #selector(BarDetailViewMainCell.ChangeTab(_:)), for: UIControlEvents.touchUpInside)

            //add to subview
            tabs.append(newTab)
            self.view.addSubview(newTab)
            
            //font
            newTab.titleLabel?.font = UIFont(name: "Montserrat", size: 15)
            
            //titles
            switch index {
            case 0:
                newTab.setTitle("Nearby", for: .normal)
            case 1:
                newTab.setTitle("Top Rated", for: .normal)
            case 2:
                newTab.setTitle("Price(Low)", for: .normal)

            default:
                break
            }
            
            //shadow
            newTab.layer.shadowOpacity = 0.6
            newTab.layer.shadowRadius = 0.5
            newTab.layer.shadowColor = UIColor.gray.cgColor
            newTab.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            newTab.clipsToBounds = false
            
            
        }
        
        //tab highlighter

        tabHighlighter = UIImageView.init(frame: CGRect(x: 0, y: locationViewHeight + tabHeight - highlighterHeight, width: tabWidth, height: highlighterHeight))
        tabHighlighter?.contentMode = .scaleAspectFit
        tabHighlighter?.image = #imageLiteral(resourceName: "triangle")
        tabHighlighter?.backgroundColor = UIColor.clear
        guard let tabHighlighter = tabHighlighter else {return}
        self.view.addSubview(tabHighlighter)
        
        //default highlight first
        tabs[0].isSelected = true
        
        //init tableView
        tableView = UITableView(frame: CGRect(x: 0, y: locationViewHeight + tabHeight, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight()))
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        //register cell
        tableView?.register(UINib(nibName: "CategoryTableCell", bundle: Bundle.main), forCellReuseIdentifier: "CategoryTableCell")
        
        tableView?.register(UINib(nibName: "BarBlownUpTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BarBlownUpTableViewCell")
        
     
        self.view.sendSubview(toBack: tableView!)
        self.view.sendSubview(toBack: locationCont.view)

    }

    func ChangeTab(_ sender: AnyObject )
    {
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView?.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
         BarManager.singleton.displayedDetailBar = nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if no bar is blown up
        if  BarManager.singleton.displayedDetailBar == nil
        {
            return displayedBarIDs.count
        }
        else
        {
            return displayedBarIDs.count + 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let bar =  BarManager.singleton.displayedDetailBar
        {
            if let ID = displayedBarIDs.index(of: bar.ID)
            {
                if indexPath.row == ID + 1
                {
                    return Sizing.blownUpCellHeight
                }
                
            }
        }
        
        
        
        return Sizing.barCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  BarManager.singleton.displayedDetailBar != nil //only if blown up is present
        {
            //blown up cell
            if indexPath.row > displayedBarIDs.count - 1 /*if out of range*/ || indexPath.row == displayedBarIDs.index(of:  BarManager.singleton.displayedDetailBar!.ID)! + 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BarBlownUpTableViewCell", for: indexPath) as! BarBlownUpTableViewCell
                
                if self.barBlownUpCell == nil
                {
                    
                    self.barBlownUpCell = cell
                    
                    //must set delegate first because initialize uses the delegate to get navigation controller (nav bar height)
                    self.barBlownUpCell!.delegate = self
                }
                
                
                
                
                
                return self.barBlownUpCell!
            }
        }

        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath) as! CategoryTableCell
        
        let barID = displayedBarIDs[indexPath.row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        if let thisBar = thisBar
        {
            cell.SetContent(bar : thisBar)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var row = indexPath.row
        //if there is currently a blown up bar cell, alter index row
        if  BarManager.singleton.displayedDetailBar != nil
        {
            guard let ID = displayedBarIDs.index(of:  BarManager.singleton.displayedDetailBar!.ID)else {return}
            
            
            if row == ID + 1
            {
                return
            }
            else if row > ID + 1
            {
                row -= 1
            }

            
        }
        let barID = displayedBarIDs[row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        guard let _ = thisBar else {return}
        
        //if no bar is being blown up, blow this one up & change view state
        if  BarManager.singleton.displayedDetailBar == nil
        {
            //close map
            SetViewState(state: 0)
            
            
            //dim others ** must dim first so that bar blown up cell does not interrup
            DimCellsBelowIndex(row)
            
            //display this bar
            BlowBarUp(bar: thisBar!)
            

        }
        else //if bar is blown up
        {
            //if blown up bar is same bar, change view state
            if  BarManager.singleton.displayedDetailBar!.ID == thisBar!.ID
            {
                SetViewState(state: 1)
                UnblowBar()
                
                //dim others ** must unblow first so that bar blownup doesnt interrup
                UnDimCellsBelowIndex(row)
            }
            else //else, means bar is different, unblow
            {
                SetViewState(state: 1)
                UnblowBar()
                
                //dim others ** must unblow first so that bar blownup doesnt interrup
                UnDimCellsBelowIndex(row)
            }
            
        }
    }

    
    
    func BlowBarUp(bar : Bar)
    {
         BarManager.singleton.displayedDetailBar = bar
        
        //scroll to row
        guard let index = displayedBarIDs.index(of: bar.ID) else {return}
        
        let thisCell = tableView?.cellForRow(at: IndexPath(row: index, section: 0))
        
        //insert blown up -> scroll to row after inserting
        tableView?.beginUpdates()
        tableView?.insertRows(at: [IndexPath(row:index + 1 ,section: 0)], with: .middle)

        CATransaction.setCompletionBlock({
            self.tableView?.setContentOffset(CGPoint(x: 0, y: CGFloat(index) * thisCell!.frame.height), animated: true)
        })
        
        tableView?.endUpdates()
        CATransaction.commit()
        
        
        //update data
        self.UpdateTabs()
        self.barBlownUpCell?.CellWillAppear()

    }
    
    func UnblowBar()
    {
        
        guard let ID =  BarManager.singleton.displayedDetailBar?.ID else {return}
        //scroll to row
        guard let index = displayedBarIDs.index(of: ID) else {return}
        
        BarManager.singleton.displayedDetailBar = nil

        
        tableView?.beginUpdates()
        tableView?.deleteRows(at: [IndexPath(row:index + 1 ,section: 0)], with: .middle)
        tableView?.endUpdates()
        
        
    }
    
    func BlowUpAnotherBar(bar : Bar)
    {
        //step 1: remove current bar
        guard let ID =  BarManager.singleton.displayedDetailBar?.ID else {return}
        //scroll to row
        guard let index = displayedBarIDs.index(of: ID) else {return}
        
        BarManager.singleton.displayedDetailBar = nil
        
        
        tableView?.beginUpdates()
        tableView?.deleteRows(at: [IndexPath(row:index + 1 ,section: 0)], with: .middle)
        
        CATransaction.setCompletionBlock({
            //step 2: when delete done, blow up
            //self.BlowBarUp(bar: bar)
            self.SetViewState(state: 1)
        })
        
        tableView?.endUpdates()
        CATransaction.commit()

    }
    
    func DimCellsBelowIndex(_ index : Int)
    {
        guard (index + 1) <= (displayedBarIDs.count-1) else {return}
        for i in (index+1)...displayedBarIDs.count-1
        {
            if let cell = tableView?.cellForRow(at: IndexPath(row: i, section: 0)) as? CategoryTableCell
            {
                cell.DimCell()
            }
            
        }
    }
    
    func UnDimCellsBelowIndex(_ index : Int)
    {
        guard index <= displayedBarIDs.count-1 else {return}
        for i in (index)...displayedBarIDs.count-1
        {
            if let cell = tableView?.cellForRow(at: IndexPath(row: i, section: 0)) as? CategoryTableCell
            {
                cell.UnDimCell()
            }
            
        }
    }
    
    
    func ToggleViewState()
    {
        if viewState == 1
        {
            SetViewState(state: 0)
        }
        else if viewState == 0
        {
            
            SetViewState(state: 1)
        }
    }
    
    func SetViewState(state : Int)
    {
        if state == 0
        {
            viewState = 0
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
                
                self.tabHighlighter!.frame.origin = CGPoint(x: self.tabHighlighter!.frame.origin.x, y: self.tabHeight - self.highlighterHeight)
                self.tableView?.frame.origin = CGPoint(x: 0, y: self.tabHeight)
                
                for tab in self.tabs
                {
                    tab.frame.origin = CGPoint(x: tab.frame.origin.x, y: 0)
                }
                
            }, completion: nil)
        }
        else if state == 1
        {
            viewState = 1
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
                
                self.tabHighlighter!.frame.origin = CGPoint(x: self.tabHighlighter!.frame.origin.x, y: self.locationViewHeight + self.tabHeight - self.highlighterHeight)
                self.tableView?.frame.origin = CGPoint(x: 0, y: self.locationViewHeight + self.tabHeight)
                
                for tab in self.tabs
                {
                    tab.frame.origin = CGPoint(x: tab.frame.origin.x, y: self.locationViewHeight)
                }
                
            }, completion: nil)
        }
    }
    
    func NavCont() -> UINavigationController {
        return self.navigationController!
    }
    
    
    //bar blown up data
    
    
    //============================================================================
    //                                 update gallery, bar icon, tabs
    //============================================================================
  
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
            self.barBlownUpCell?.descriptionCont.tableView?.reloadData()
        })
    }
    
    func UpdateReviewTab()
    {
        DispatchQueue.main.async(execute: {
            self.barBlownUpCell?.reviewCont.ReloadReviewTableData()
        })
        
    }
    
    func UpdateDiscountTab()
    {
        DispatchQueue.main.async(execute: {
            self.barBlownUpCell?.discountCont.tableView?.reloadData()
        })
    }
}
