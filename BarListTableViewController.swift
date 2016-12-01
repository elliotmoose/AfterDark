//
//  BarListViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 14/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation
import UIKit


class BarListTableViewController: UIViewController,BarManagerToListTableDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var barDisplayMode: DisplayBarListMode = .alphabetical
    var activityIndicator : UIActivityIndicatorView?
    var refreshButton : UIBarButtonItem?
    
    
    //============================================================================
    //                         loading and initializing
    //============================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //*******************************************************************
        //                  app start, main init throughout
        //*******************************************************************
        
        //login page
        Account.singleton.Load()
        if Account.singleton.user_name == "" || Account.singleton.user_name == nil
        {
            if !Settings.bypassLoginPage
            {
                self.present(LoginViewController.singleton, animated: false, completion: nil)
            }
        }
        
        //ui and non ui initializing
        self.Initialize()
        
        //set first page when app loads
        self.navigationController?.tabBarController?.selectedIndex = 1
        
        //dummy app
        guard Settings.dummyAppOn == false else {
            DummyMode.singleton.Populate()
            return
        }
        
        //load data
        self.RetrieveDataFromUrls()
        

        

    }
    


    
    //============================================================================
    //                         internal initializing
    //============================================================================
    
    func Initialize()
    {
        //ui init*********************************************************************
        DispatchQueue.main.async {
            //tableview init
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            
            //init refresh button
            self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
            self.activityIndicator?.color = UIColor.gray
            self.activityIndicator?.startAnimating()
            self.refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(BarListTableViewController.refresh))
            self.navigationItem.rightBarButtonItem = self.refreshButton
            
            //nav bar and tab bar translucency for framing purposes
            self.navigationController?.navigationBar.isTranslucent = false
            self.tabBarController?.tabBar.isTranslucent = false
            
            
            
            
            //control tool bar
            let toolBarHeight = CGFloat(40)
            
            let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: toolBarHeight))
            
            let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)

            //custom view
            let sortbyView = UIButton(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: toolBarHeight))
            //arrow indicator in view
            let arrow = UIImageView.init(image: #imageLiteral(resourceName: "arrow"))
            arrow.frame  = CGRect(x: Sizing.ScreenWidth() - Sizing.HundredRelativeWidthPts(), y: toolBarHeight/4, width: toolBarHeight/2, height: toolBarHeight/2)
            
            
            
            
            
            sortbyView.setTitle("Sort by: A-Z", for: .normal)
            sortbyView.setTitleColor(UIColor.black, for: .normal)
            sortbyView.backgroundColor = UIColor.gray
            sortbyView.addTarget(self, action: #selector(self.ShowChangeListSortView), for: .touchUpInside)
            
            //button
            let sortbybutton =  UIBarButtonItem.init(customView: sortbyView)
            
            
            toolBar.items = [flexSpace,sortbybutton,flexSpace]
            
            //add tool bar
            sortbyView.addSubview(arrow)
            self.view.addSubview(toolBar)
            

        
            //shift down bar list tableview for control view
            self.tableView.frame = CGRect(x: 0, y: toolBarHeight, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight())
            
            
            
        }
        
        //non ui init*********************************************************************
        DispatchQueue.global(qos: .default).async{
        
            //register bar list table view cell
                self.tableView.register(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")
            
            //set self as bar manager delegate
            BarManager.singleton.listDelegate = self
            
        
        }
        



    }

    
    //============================================================================
    //                         loading all data from urls
    //============================================================================
    func RetrieveDataFromUrls()
    {
        //loading of data from internet******************************************************
        DispatchQueue.global(qos: .default).async{
            
            //set spinner
            self.ShowTopRightSpinner()
            
            //init other views as this is the first view loaded
            BarManager.singleton.LoadGenericBarData({()->Void in
                
                //load bar details
                BarManager.singleton.LoadAllNonImageDetailBarData({()->Void in
                    
                })
                
                //load categories
                CategoriesManager.singleton.LoadAllCategories()
                
                //load reviews
                ReviewManager.singleton.LoadAllReviews()
                
                //load discounts
                DiscountManager.singleton.LoadAllDiscounts()
                
                //change back to refresh button once loading done
                self.HideTopRightSpinner()
                
            })
            
        }

    }
    
    
    func UpdateBarListTableDisplay()
    {
        //arrange before display
        BarManager.singleton.ArrangeBarList(barDisplayMode)
        
        //after arrange -> load
        self.ReloadTable()
    }
    
    
    func UpdateCellForBar(_ bar : Bar)
    {
        //get bar indexPath in display Bar List
        var indexPath: IndexPath?
        for sectionIndex in 0...BarManager.singleton.displayBarList.count-1
        {
            let section = BarManager.singleton.displayBarList[sectionIndex]
            for rowIndex in 0...section.count-1
            {
                let barx = section[rowIndex]
                if bar.name == barx.name
                {
                    indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        
        if let indexPath = indexPath
        {
            //update that index path
            DispatchQueue.main.async {
                let indexPaths = [indexPath]
                self.tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.none)
                
                //check if its being viewed
                if BarManager.singleton.displayedDetailBar.name == bar.name
                {
                    //update that icon in bar detail view
                    BarDetailTableViewController.singleton.UpdateBarIcon()
                    
                    //update that icon in discount detail view controller
                    DiscountDetailViewController.singleton.barIconImageView.image = bar.icon

                }
            }
        }


    }
    
    func ReloadTable()
    {
        DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }

    //============================================================================
    //                                 number of section and rows
    //============================================================================
    func numberOfSections(in tableView: UITableView) -> Int
    {
        let count = BarManager.singleton.displayBarList.count
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = BarManager.singleton.displayBarList[section].count

        return count
    }

    //============================================================================
    //                                create bar cells
    //============================================================================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarListTableViewCell", for: indexPath) as! BarListTableViewCell
        let thisSection = BarManager.singleton.displayBarList[indexPath.section]
        let thisBar = thisSection[indexPath.row]
        
        cell.SetContent(thisBar.icon, barName: thisBar.name, barRating: thisBar.rating)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
    //============================================================================
    //                                 selected bar cell
    //============================================================================
    //show bar detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //prep for display
        BarManager.singleton.DisplayBarDetails(BarManager.singleton.displayBarList[indexPath.section][indexPath.row])
        BarDetailTableViewController.singleton.UpdateDisplays()
        self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

    //============================================================================
    //                                 section header
    //============================================================================
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        let firstSection  = BarManager.singleton.displayBarList[section]

        if firstSection.count == 0
        {
            return ""
        }
        else
        {
            let firstBarInSection = firstSection[0]
            return String(describing: firstBarInSection.name.characters.first!)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = ColorManager.barListSectionHeaderColor
    
    }
    
    //============================================================================
    //                                 refresh button
    //============================================================================
    
    func refresh()
    {

        
        DispatchQueue.main.async(execute: {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
        })
        
        //init other views as this is the first up
        BarManager.singleton.LoadGenericBarData({()->Void in
            
            BarManager.singleton.LoadAllNonImageDetailBarData({()->Void in
                
            })
            
            ReviewManager.singleton.LoadAllReviews()
            
            DiscountManager.singleton.LoadAllDiscounts()
            
            DispatchQueue.main.async(execute: {
                self.navigationItem.rightBarButtonItem = self.refreshButton
            })
            
        })
    }
    
    func ShowTopRightSpinner()
    {
        //set loading spinner
        DispatchQueue.main.async(execute: {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
        })
    }
    
    func HideTopRightSpinner()
    {
        DispatchQueue.main.async(execute: {
            self.navigationItem.rightBarButtonItem = self.refreshButton
        })
    }
    
    func ShowChangeListSortView()
    {
        self.navigationController?.pushViewController(ChangeListSortViewController.singleton, animated: true)
    }
    
}

