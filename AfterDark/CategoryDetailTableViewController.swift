//
//  CategoryDetailTableViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainCellDelegate,UISearchResultsUpdating {
    
    //constants
    let tabHeight : CGFloat = Sizing.catTabHeight
    let highlighterHeight : CGFloat = 10
    let locationViewHeight = Sizing.ScreenHeight()/4

    var awaitUpdate = false
    var awaitingArrangement : Arrangement = .featured
    
    var currentArrangement : Arrangement = .featured
    //objects
    var tableView : UITableView?
    
    var toBeDisplayedBarIDs = [String]()
    var displayedBarIDs = [String]()
    var filteredDisplayedBarIDs = [String]()
    var awaitingBarIDs = [String]()
    
    var awaitingBlowUpBarID : String?
    
    let locationCont = LocationViewController()
    
    var tabs = [UIButton]()
    
    var tabHighlighter: UIImageView?
    
    var viewState = 1 //0 = no maps 1 = maps and bar list 2 = full maps..?
    
    var barBlownUpCell : BarBlownUpTableViewCell?
    
    var recentSelectedIndexPath : IndexPath?
    
    //let searchController = UISearchController(searchResultsController: nil)
    var searchBarEnabled = false
    //runtime object variables
    //var barBlownUp : Bar?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init location view
        locationCont.view.backgroundColor = UIColor.darkGray
        locationCont.view.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: locationViewHeight)
        self.addChildViewController(locationCont)
        self.view.addSubview(locationCont.view)
        
        //init tab buttons

        let numberOfTabs = 4
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
            newTab.addTarget(self, action: #selector(self.ChangeTabPressed(_:)), for: UIControlEvents.touchUpInside)

            //add to subview
            tabs.append(newTab)
            self.view.addSubview(newTab)
            
            //font
            newTab.titleLabel?.font = UIFont(name: "Mohave-Bold", size: 16.5)
            
            //titles
            switch index {
            case 0:
                newTab.setTitle("Featured", for: .normal)
            case 1:
                newTab.setTitle("Top Rated", for: .normal)
            case 2:
                newTab.setTitle("Nearby", for: .normal)
            case 3:
                newTab.setTitle("Discounts", for: .normal)
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
        let tableViewHeight = Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - self.tabHeight - Sizing.navBarHeight - self.locationViewHeight
        
        tableView = UITableView(frame: CGRect(x: 0, y: self.locationViewHeight + self.tabHeight , width: Sizing.ScreenWidth(), height: tableViewHeight))
        
        tableView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.1, alpha: 1)
        tableView?.separatorColor = UIColor(hue: 0, saturation: 0, brightness: 0.4, alpha: 1)
        tableView?.tableFooterView = UIView() //remove seperator lines
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        //register cell
        tableView?.register(UINib(nibName: "BarSummaryTableCell", bundle: Bundle.main), forCellReuseIdentifier: "BarSummaryTableCell")
        
        tableView?.register(UINib(nibName: "BarBlownUpTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BarBlownUpTableViewCell")
        
     
        self.view.sendSubview(toBack: tableView!)
        self.view.sendSubview(toBack: locationCont.view)
        
        self.automaticallyAdjustsScrollViewInsets = false

        definesPresentationContext = true

        self.extendedLayoutIncludesOpaqueBars = false

        self.edgesForExtendedLayout = []

    }
    
    func ChangeTabPressed(_ sender: AnyObject )
    {
        let button = sender as! UIButton
        ChangeTab(sender.tag)
    }
    
    func ChangeTab(_ index : Int)
    {
        //select ui
        for tab in tabs
        {
            if tab.tag != index
            {
                tab.isSelected = false
            }
            else
            {
                tab.isSelected = true
            }
        }
        
        MoveHighlight(index)
        
        //******* UNBLOW FIRST
        SetViewState(state: 1)

        if let _ = BarManager.singleton.displayedDetailBar
        {
            UnblowBarWithHandler
            {
                switch index {
                case 0:
                    self.SetArrangement(arrangement: .featured)
                case 1:
                    self.SetArrangement(arrangement: .avgRating)
                case 2:
                    self.SetArrangement(arrangement: .nearby)
                case 3:
                    self.SetArrangement(arrangement: .bestDiscount)
                default:
                    self.SetArrangement(arrangement: .avgRating)
            
                }
                
                if self.awaitUpdate
                {
                    self.SetArrangementWithBarIDs(arrangement: self.currentArrangement, barIDs: self.awaitingBarIDs)
                    self.awaitUpdate = false
                }
                
                //update UI
                self.UpdateUI()
            }
        }
        else
        {
            switch index {
            case 0:
                self.SetArrangement(arrangement: .featured)
            case 1:
                self.SetArrangement(arrangement: .avgRating)
            case 2:
                self.SetArrangement(arrangement: .nearby)
            case 3:
                self.SetArrangement(arrangement: .bestDiscount)
            default:
                self.SetArrangement(arrangement: .avgRating)
            }
            
            if self.awaitUpdate
            {
                self.SetArrangementWithBarIDs(arrangement: self.currentArrangement, barIDs: self.awaitingBarIDs)
                self.awaitUpdate = false
            }
            
            //update UI
            UpdateUI()

        }
        
        guard let recentSelectedIndexPath = recentSelectedIndexPath else {return}
        if let recentSelectedCell = tableView?.cellForRow(at: recentSelectedIndexPath) as? BarSummaryTableCell
        {
            recentSelectedCell.SetDeselected()
            self.recentSelectedIndexPath = nil
        }
        
        
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
        
        UpdateUI()
        
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        awaitingBlowUpBarID = nil
        SetViewState(state: 1)
        UnblowBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //auto selection
        if let barID = awaitingBlowUpBarID
        {
            guard let bar = BarManager.singleton.BarFromBarID(barID) else {return}
            self.recentSelectedIndexPath = nil
            
            self.SetViewState(state: 0)
            self.BlowBarUp(bar: bar)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var displayedIDs = displayedBarIDs

        
        
        //if no bar is blown up
        if  BarManager.singleton.displayedDetailBar == nil
        {
            return displayedIDs.count
        }
        else
        {
            return displayedIDs.count + 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var displayedIDs = displayedBarIDs
        
        
        if let bar =  BarManager.singleton.displayedDetailBar
        {
            if let ID = displayedIDs.index(of: bar.ID)
            {
                if indexPath.row == ID + 1
                {
                    return Sizing.blownUpCellHeight
                }
                
            }
        }
        
        
        
        return Sizing.barCellHeight
    }
    
    //==================================================================================================================================================================
    //                                                                              CELL FOR ROW
    //==================================================================================================================================================================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayedIDs = displayedBarIDs


        if  BarManager.singleton.displayedDetailBar != nil //only if blown up is present
        {
            //blown up cell
            if indexPath.row > displayedIDs.count - 1 /*if out of range*/ || indexPath.row == displayedIDs.index(of:  BarManager.singleton.displayedDetailBar!.ID)! + 1
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

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarSummaryTableCell", for: indexPath) as! BarSummaryTableCell
        
        //ensure that selection isnt mixed up during cell reuse
        if indexPath != recentSelectedIndexPath
        {
            cell.SetDeselected()
        }
        else
        {
            cell.SetSelected()
        }
        
        let barID = displayedIDs[indexPath.row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        if let thisBar = thisBar
        {
            cell.SetContent(bar : thisBar)
        }
        
        return cell
    }
    
    //==================================================================================================================================================================
    //                                                                              SELECT
    //==================================================================================================================================================================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var displayedIDs = displayedBarIDs

        
        let row = indexPath.row
        
        
        
        let barID = displayedIDs[row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        guard let _ = thisBar else {return}
        
        
       
        //selection, location, and blow up
        if let cell = tableView.cellForRow(at: indexPath) as? BarSummaryTableCell
        {
            
            //unblow
            if BarManager.singleton.displayedDetailBar != nil //THIS IS WHEN ITS BLOW UP -> CLOSE IMMEDIATELY
            {
                //close immediately
                SetViewState(state: 1)
                UnblowBarWithHandler
                {
                    if self.awaitUpdate
                    {
                        self.SetArrangementWithBarIDs(arrangement: self.currentArrangement, barIDs: self.awaitingBarIDs)
                        self.UpdateUI()                        
                        self.awaitUpdate = false
                    }
                }

            }
            else //THIS IS WHEN ITS NOT BLOWN UP -> SELECTION AND MOVEMENT TO BLOW UP
            {
                guard let recentSelectedIndexPath = recentSelectedIndexPath else {
                
                    //if there hasnt been a selection, select this
                    cell.SetSelected()
                    self.recentSelectedIndexPath = indexPath
                    locationCont.SetBar(bar : thisBar!)
                    return
                }
                
                
                //deselect previous
                if let recentSelectedCell = tableView.cellForRow(at: recentSelectedIndexPath) as? BarSummaryTableCell
                {
                    if recentSelectedIndexPath == indexPath //if same cell
                    {
                        //DESELECT ALL CELLS -> BLOW UP
                        cell.SetDeselected()
                        self.recentSelectedIndexPath = nil

                        //BLOW UP (ABOVE CONDITION ALREADY CONFIRMS THERE IS NO BAR BLOWN UP HERE)
                        //close map and blow up
                        SetViewState(state: 0)
                        BlowBarUp(bar: thisBar!)
                        
                    
                        
                        
                    }
                    else //if diff cell, select this, deselect previous
                    {
                        recentSelectedCell.SetDeselected()
                        cell.SetSelected()
                        self.recentSelectedIndexPath = indexPath
                        locationCont.SetBar(bar : thisBar!)
                    }
                }
                else //if first cell, select this
                {
                    cell.SetSelected()
                    self.recentSelectedIndexPath = indexPath
                    locationCont.SetBar(bar : thisBar!)
                }
                
                
            }
            
            
        }
        
        
        
    }

    
    func BlowBarUp(bar : Bar)
    {
        var displayedIDs = displayedBarIDs
        
        BarManager.singleton.displayedDetailBar = bar
        
        guard let index = displayedIDs.index(of: bar.ID) else {return}
        
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
     
        var displayedIDs = displayedBarIDs

        guard let ID =  BarManager.singleton.displayedDetailBar?.ID else {return}
        //scroll to row
        guard let index = displayedIDs.index(of: ID) else {return}
        
        BarManager.singleton.displayedDetailBar = nil

        
        tableView?.beginUpdates()
        tableView?.deleteRows(at: [IndexPath(row:index + 1 ,section: 0)], with: .middle)
        tableView?.endUpdates()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }, completion: nil)
        
        recentSelectedIndexPath = nil
    }
    func UnblowBarWithHandler(_ handler : @escaping () -> Void)
    {
        var displayedIDs = displayedBarIDs
        
        guard let ID =  BarManager.singleton.displayedDetailBar?.ID else {return}
        //scroll to row
        guard let index = displayedIDs.index(of: ID) else {return}
        
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

        recentSelectedIndexPath = nil
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
        

        if state == 0 // shift up
        {

            viewState = 0
            self.tableView?.isScrollEnabled = false
         
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
                
                //update tab origin
                self.tabHighlighter!.frame.origin = CGPoint(x: self.tabHighlighter!.frame.origin.x, y: self.tabHeight - self.highlighterHeight)
                
                //update table view content size and frame
                let tableViewHeight = Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - self.tabHeight - Sizing.navBarHeight
                
                self.tableView?.frame = CGRect(x: 0, y: self.tabHeight, width: Sizing.ScreenWidth(), height: tableViewHeight)
                
                
                for tab in self.tabs
                {
                    tab.frame.origin = CGPoint(x: tab.frame.origin.x, y: 0)
                }
                
                
            }, completion: nil)
            
            

        }
        else if state == 1 // shift down
        {

            viewState = 1
            self.tableView?.isScrollEnabled = true
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
                
                self.tabHighlighter!.frame.origin = CGPoint(x: self.tabHighlighter!.frame.origin.x, y: self.locationViewHeight + self.tabHeight - self.highlighterHeight)
                let tableViewHeight = Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - self.tabHeight - Sizing.navBarHeight - self.locationViewHeight
                //update table view content size and frame
                self.tableView?.frame = CGRect(x: 0, y: self.locationViewHeight + self.tabHeight, width: Sizing.ScreenWidth(), height: tableViewHeight)
                

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
            self.barBlownUpCell?.reviewCont.reloadData()
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
    func SetBarIDs(barIDs : [String])
    {
        //set bar Ids
        self.toBeDisplayedBarIDs = barIDs
        
        DispatchQueue.global(qos: .default).async
            {
                //if a bar is currently on display
                if BarManager.singleton.displayedDetailBar != nil
                {
                    //change information within current display
                    self.UpdateTabs()
                    
                    //set list
                    self.awaitingBarIDs = barIDs
                    self.awaitUpdate = true
                    
                }
                else
                {
                    //self.SetArrangementWithBarIDs(arrangement: self.currentArrangement, barIDs: barIDs)
                    self.SetArrangement(arrangement: self.currentArrangement)
                    
                    //can update cuz none showing
                    self.UpdateUI()
                }
        }
    }
    
    func SetArrangement(arrangement : Arrangement)
    {
        
        self.currentArrangement = arrangement
        
        //step 1: convert bar list IDs into a bar list
        var barList = [Bar]()
        for ID in self.toBeDisplayedBarIDs
        {
            let bar = BarManager.singleton.BarFromBarID(ID)
            if let _ = bar
            {
                barList.append(bar!)
            }
        }
        
        //step 2: arrange based on attribute
        
        
        switch arrangement {
            
        case .featured:
            
            //step 1: sieve out exclusive
            var featuredList = [Bar]()
            for bar in barList
            {
                if bar.isExclusive
                {
                    featuredList.append(bar)
                }
            }
            
            
            //step 2 sort by best discount percentage
            featuredList.sort(by: {$0.bestDiscount > $1.bestDiscount})
            
            barList = featuredList
            
        case .nearby:
            barList.sort(by: {$0.distanceFromClient < $1.distanceFromClient})
            
        case .avgRating:
            barList.sort(by: {$0.rating.avg > $1.rating.avg})
            
        case .priceLow:
            barList.sort(by: {$0.priceDeterminant < $1.priceDeterminant})
            
        case .bestDiscount:
            barList.sort(by: {$0.bestDiscount > $1.bestDiscount})

        }
        
        
        //step 3: convert bar list back into bar IDs
        self.displayedBarIDs.removeAll()
        for bar in barList
        {
            self.displayedBarIDs.append(bar.ID)
        }
        
        
    }
    
    func SetArrangementWithBarIDs(arrangement : Arrangement, barIDs : [String])
    {
        
        self.currentArrangement = arrangement
        
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
            
        case .featured:
            
            //step 1: sieve out exclusive
            var featuredList = [Bar]()
            for bar in barList
            {
                if bar.isExclusive
                {
                    featuredList.append(bar)
                }
            }
            
            
            //step 2 sort by best discount percentage
            featuredList.sort(by: {$0.bestDiscount > $1.bestDiscount})
            
            barList = featuredList
            
        case .nearby:
            barList.sort(by: {$0.distanceFromClient < $1.distanceFromClient})
            
        case .avgRating:
            barList.sort(by: {$0.rating.avg > $1.rating.avg})
            
        case .priceLow:
            barList.sort(by: {$0.priceDeterminant < $1.priceDeterminant})
            
        case .bestDiscount:
            barList.sort(by: {$0.bestDiscount > $1.bestDiscount})

        }
        
        
        //step 3: convert bar list back into bar IDs
        self.displayedBarIDs.removeAll()
        for bar in barList
        {
            self.displayedBarIDs.append(bar.ID)
        }

    }
    
    func UpdateUI()
    {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
        
    }
    
    //search functions
    
    func filterBars(searchText: String, scope: String = "All") {
        
        filteredDisplayedBarIDs = displayedBarIDs.filter { barID in
            
            if let bar = BarManager.singleton.BarFromBarID(barID)
            {
                return bar.name.lowercased().contains(searchText.lowercased())
            }
            else
            {
                return false
            }
            
        }
        
        //update UI
        UpdateUI()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        

        if let _ = BarManager.singleton.displayedDetailBar
        {
            return
        }
        
        guard let recentSelectedIndexPath = recentSelectedIndexPath else {return}
        
        if let selectedCell = tableView?.cellForRow(at: recentSelectedIndexPath) as? BarSummaryTableCell
        {
            selectedCell.SetDeselected()
            self.recentSelectedIndexPath = nil
        }

        filterBars(searchText: searchController.searchBar.text!)
    }


    
    //DELEGATE FUNCTIONS
    func UpdateCellForBar(_ bar: Bar) {

        var displayedIDs = displayedBarIDs

        
        //if a bar is currently on display
        if BarManager.singleton.displayedDetailBar != nil
        {
            
        }
        else
        {
            //step 1: find out bar index in display
            let index = displayedIDs.index(of: bar.ID)
            if let index = index
            {
                //step 2: update cell for that index
                tableView?.reloadRows(at: [IndexPath(row: index, section : 0)], with: .none)
            }
        }
    }
    
    
    
    
    func NavCont() -> UINavigationController {
        return self.navigationController!
    }
    
    
}
