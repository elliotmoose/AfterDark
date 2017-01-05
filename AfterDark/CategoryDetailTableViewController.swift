//
//  CategoryDetailTableViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainCellDelegate,BarManagerToListTableDelegate {
    
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
    
    var recentSelectedCell : CategoryTableCell?
    
    //runtime object variables
    //var barBlownUp : Bar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //non ui init
        BarManager.singleton.catListDelegate = self
        
        
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
        tableView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.1, alpha: 1)
        tableView?.separatorColor = UIColor(hue: 0, saturation: 0, brightness: 0.4, alpha: 1)
        tableView?.tableFooterView = UIView() //remove seperator lines
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
        
        //******* UNBLOW FIRST
        SetViewState(state: 1)

        if let _ = BarManager.singleton.displayedDetailBar
        {
            UnblowBarWithHandler {
                switch sender.tag {
                case 0:
                    self.SetArrangement(arrangement: .nearby)
                case 1:
                    self.SetArrangement(arrangement: .avgRating)
                case 2:
                    self.SetArrangement(arrangement: .priceLow)
                    
                default:
                    self.SetArrangement(arrangement: .avgRating)
                }
            }
        }
        else
        {
            switch sender.tag {
            case 0:
                self.SetArrangement(arrangement: .nearby)
            case 1:
                self.SetArrangement(arrangement: .avgRating)
            case 2:
                self.SetArrangement(arrangement: .priceLow)
                
            default:
                self.SetArrangement(arrangement: .avgRating)
            }

        }
        
        recentSelectedCell?.SetDeselected()
        recentSelectedCell = nil
        
       
        
        
        
        
    }
    
    func MoveHighlight(_ index:Int)
    {
        guard let _ = tabHighlighter else {return}
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: UIViewAnimationOptions(), animations: {
            
            
            self.tabHighlighter!.frame = CGRect( x: self.tabHighlighter!.frame.size.width * CGFloat(index),  y: self.tabHighlighter!.frame.origin.y,  width: self.tabHighlighter!.frame.size.width,  height: self.tabHighlighter!.frame.size.height)
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //load distancing
        BarManager.singleton.ReloadAllDistanceMatrix()
        
        //since view will appear is called before will disappear, 2 instances of this class will clash as it will load another before it unloads the previous displayed bar
        BarManager.singleton.displayedDetailBar = nil
        self.tableView?.reloadData()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        SetViewState(state: 1)
         UnblowBar()
        
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
        
        
       
        //selection, location, and blow up
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableCell
        {
            
            //unblow
            if BarManager.singleton.displayedDetailBar != nil //THIS IS WHEN ITS BLOW UP -> CLOSE IMMEDIATELY
            {
                //close immediately
                SetViewState(state: 1)
                UnblowBar()
            }
            else //THIS IS WHEN ITS NOT BLOWN UP -> SELECTION AND MOVEMENT TO BLOW UP
            {
                
                //deselect previous
                if let _ = recentSelectedCell
                {
                    if recentSelectedCell! == cell //if same cell
                    {
                        
                        //DESELECT ALL CELLS -> BLOW UP
                        cell.SetDeselected()
                        recentSelectedCell = nil

                        //BLOW UP (ABOVE CONDITION ALREADY CONFIRMS THERE IS NO BAR BLOWN UP HERE)
                        //close map and blow up
                        SetViewState(state: 0)
                        BlowBarUp(bar: thisBar!)
                        
                        
                        
                    }
                    else //if diff cell, select this, deselect previous
                    {
                        recentSelectedCell!.SetDeselected()
                        cell.SetSelected()
                        recentSelectedCell = cell
                        locationCont.SetBar(bar : thisBar!)
                    }
                }
                else //if first cell, select this
                {
                    cell.SetSelected()
                    recentSelectedCell = cell
                    locationCont.SetBar(bar : thisBar!)
                }
                
                
            }
            
            
        }
        
        
        
    }

    
    
    func BlowBarUp(bar : Bar)
    {
         BarManager.singleton.displayedDetailBar = bar
        
        guard let index = displayedBarIDs.index(of: bar.ID) else {return}
        
        let thisCell = tableView?.cellForRow(at: IndexPath(row: index, section: 0))
        
        //insert blown up -> scroll to row after inserting
        tableView?.beginUpdates()
        
            //insert
        tableView?.insertRows(at: [IndexPath(row:index + 1 ,section: 0)], with: .middle)

            //scroll to row
        CATransaction.setCompletionBlock({
            //self.tableView?.setContentOffset(CGPoint(x: 0, y: CGFloat(index) * thisCell!.frame.height), animated: true)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.tableView?.contentInset = UIEdgeInsetsMake(-(CGFloat(index) * thisCell!.frame.height), 0, 0, 0)
            }, completion: nil)
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
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }, completion: nil)
        
        recentSelectedCell = nil
    }
    func UnblowBarWithHandler(_ handler : @escaping () -> Void)
    {
        
        guard let ID =  BarManager.singleton.displayedDetailBar?.ID else {return}
        //scroll to row
        guard let index = displayedBarIDs.index(of: ID) else {return}
        
        BarManager.singleton.displayedDetailBar = nil
        
        
        tableView?.beginUpdates()
        CATransaction.setCompletionBlock({
            handler()
        })
        
        tableView?.deleteRows(at: [IndexPath(row:index + 1 ,section: 0)], with: .middle)
        tableView?.endUpdates()
        CATransaction.commit()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }, completion: nil)

        recentSelectedCell = nil
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
    

    
    //bar blown up data
    
    
    //============================================================================
    //                                 update gallery, bar icon, tabs
    //============================================================================
  
    func UpdateTabs()
    {
        UpdateDetailsTab()
        UpdateDescriptionTab()
        UpdateReviewTab()
        UpdateDiscountTab()
    }
    
    func UpdateDetailsTab()
    {
        //update bar details tab
        DispatchQueue.main.async(execute: {
            self.barBlownUpCell?.detailsCont.tableView?.reloadData()
        })
    }
    
    func UpdateDiscountTab()
    {
        DispatchQueue.main.async(execute: {
            self.barBlownUpCell?.discountCont.tableView?.reloadData()
        })
    }
    
    func UpdateReviewTab()
    {
        DispatchQueue.main.async(execute: {
            //self.barBlownUpCell?.reviewCont.ReloadReviewTableData()
        })
        
    }
    

    func UpdateDescriptionTab()
    {
        //update bar description tab
        DispatchQueue.main.async(execute: {
            self.barBlownUpCell?.descriptionCont.ReloadData()
        })
    }
    
    //============================================================================
    //                                 Arrangement and displaying of bars
    //============================================================================
    func SetArrangementWithBarList(arrangement : Arrangement, barListInput : [Bar])
    {
        var barList = barListInput
        //step 2: arrange based on attribute
        switch arrangement {
        case .nearby:
            barList.sort(by: {$0.distanceFromClient < $1.distanceFromClient})
            
        case .avgRating:
            barList.sort(by: {$0.rating.avg > $1.rating.avg})
            
        case .priceLow:
            barList.sort(by: {$0.rating.price > $1.rating.price})
  
        }
        
        
        //step 3: convert bar list back into bar IDs
        displayedBarIDs.removeAll()
        for bar in barList
        {
            displayedBarIDs.append(bar.ID)
        }
        
        //step 4: update ui
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func SetArrangement(arrangement : Arrangement)
    {
        //step 1: convert bar list IDs into a bar list
        var barList = [Bar]()
        for ID in displayedBarIDs
        {
            let bar = BarManager.singleton.BarFromBarID(ID)
            if let _ = bar
            {
                barList.append(bar!)
            }
        }
        
        //step 2: arrange based on attribute
        
        
        switch arrangement {
        case .nearby:
            barList.sort(by: {$0.distanceFromClient < $1.distanceFromClient})

        case .avgRating:
            barList.sort(by: {$0.rating.avg > $1.rating.avg})

        case .priceLow:
            barList.sort(by: {$0.rating.price > $1.rating.price})

        }
        
        
        //step 3: convert bar list back into bar IDs
        displayedBarIDs.removeAll()
        for bar in barList
        {
            displayedBarIDs.append(bar.ID)
        }
        
        //step 4: update ui
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func SetArrangementWithBarIDs(arrangement : Arrangement, barIDs : [String])
    {
        //step 1: convert bar list IDs into a bar list
        var barList = [Bar]()
        for ID in barIDs
        {
            let bar = BarManager.singleton.BarFromBarID(ID)
            if let _ = bar
            {
                barList.append(bar!)
            }
        }
        
        //step 2: arrange based on attribute
        
        
        switch arrangement {
        case .nearby:
            barList.sort(by: {$0.distanceFromClient < $1.distanceFromClient})
            
        case .avgRating:
            barList.sort(by: {$0.rating.avg > $1.rating.avg})
            
        case .priceLow:
            barList.sort(by: {$0.rating.price > $1.rating.price})
            
        }
        
        
        //step 3: convert bar list back into bar IDs
        displayedBarIDs.removeAll()
        for bar in barList
        {
            displayedBarIDs.append(bar.ID)
        }
        
        //step 4: update ui
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    //DELEGATE FUNCTIONS
    func UpdateCellForBar(_ bar: Bar) {
        //step 1: find out bar index in display
        let index = displayedBarIDs.index(of: bar.ID)
        if let index = index
        {
            //step 2: update cell for that index
            tableView?.reloadRows(at: [IndexPath(row: index, section : 0)], with: .none)
        }
    }
    
    func UpdateBarListTableDisplay() {
        //refresh display IDs for this cat!!
        
        //then arrangement with ids
    }
    
    
    
    func NavCont() -> UINavigationController {
        return self.navigationController!
    }
    
    
}
