//
//  BarListCollectionViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/12/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BarListCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,BarManagerToListTableDelegate,SortListDelegate ,LoggedInEventDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var barDisplayMode: DisplayBarListMode = .avgRating
    var activityIndicator : UIActivityIndicatorView?
    var refreshButton : UIBarButtonItem?
    
    var sortByButton = UIButton()
    
    //============================================================================
    //                         loading and initializing
    //============================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //*******************************************************************
        //                  app start, main init throughout
        //*******************************************************************
        
        //login page
        var loggedIn = false //this is so that we can initialize before we load data in
        Account.singleton.delegate = self
        Account.singleton.Load()
        if Account.singleton.user_name == "" || Account.singleton.user_name == nil
        {
            if !Settings.bypassLoginPage
            {
                self.present(LoginViewController.singleton, animated: false, completion: nil)
            }
        }
        else
        {
            loggedIn = true
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
        
        if loggedIn
        {
            self.hasLoggedIn()
        }

    
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    //============================================================================
    //                         internal initializing
    //============================================================================
    
    func Initialize()
    {
        //ui init*********************************************************************
        DispatchQueue.main.async {
            
            //collection view delegate
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            
            //collection view items
            let toolBarHeight = CGFloat(40)

            //collection view init
            self.collectionView.frame = CGRect(x: 0, y: toolBarHeight, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - Sizing.navBarHeight - toolBarHeight)
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: Sizing.itemWidth, height: Sizing.itemHeight)
            layout.sectionInset = UIEdgeInsets(top: Sizing.itemInsetFromEdge, left: 0, bottom: Sizing.itemInsetFromEdge, right: 0)

            self.collectionView.collectionViewLayout = layout
            
            //init refresh button
            self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
            self.activityIndicator?.startAnimating()
            self.refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(BarListCollectionViewController.refresh))
            self.navigationItem.rightBarButtonItem = self.refreshButton
            
            //nav bar and tab bar translucency for framing purposes
            self.navigationController?.navigationBar.isTranslucent = false
            self.tabBarController?.tabBar.isTranslucent = false
            
            //colors
            self.navigationController?.navigationBar.tintColor = ColorManager.themeBright
            self.navigationController?.navigationBar.barTintColor = UIColor.black
            self.navigationController?.navigationBar.barStyle = .black;
            self.collectionView.backgroundColor = ColorManager.barListBGColor
            self.activityIndicator?.color = UIColor.gray
            self.tabBarController?.tabBar.tintColor = ColorManager.themeBright

            //========================================================================================
            //                                      sorting
            //========================================================================================
            
            
            //tool bar items
            let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: toolBarHeight))
            let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            
            //tool bar view
            self.sortByButton = UIButton(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: toolBarHeight))
            //let arrow = UIImageView.init(image: #imageLiteral(resourceName: "arrow"))
            //arrow.frame  = CGRect(x: Sizing.ScreenWidth() - Sizing.HundredRelativeWidthPts(), y: toolBarHeight/4, width: toolBarHeight/2, height: toolBarHeight/2)
            self.sortByButton .setTitle("Sort by: Top Rated", for: .normal)
            self.sortByButton.titleLabel?.font = UIFont(name: "Mohave", size: 19)
            self.sortByButton .setTitleColor(UIColor.black, for: .normal)
            self.sortByButton .backgroundColor = ColorManager.barListSortButtonColor
            self.sortByButton .addTarget(self, action: #selector(self.ShowChangeListSortView), for: .touchUpInside)
            self.AddShadow(view: self.sortByButton)
            //button
            let sortbutton =  UIBarButtonItem.init(customView: self.sortByButton)
            
            toolBar.items = [flexSpace,sortbutton,flexSpace]
            
            //add tool bar
            //self.sortByButton .addSubview(arrow)
            self.view.addSubview(toolBar)
            
            //delegate
            ChangeListSortViewController.singleton.delegate = self
            
            
            
        }
        
        //non ui init*********************************************************************
        DispatchQueue.global(qos: .default).async{
            
            //register bar list table view cell
            self.collectionView.register(UINib(nibName: "BarListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BarListCollectionViewCell")
            //set self as bar manager delegate
            BarManager.singleton.listDelegate = self
            
            
        }
        
        
        
        
    }
    
    
    //============================================================================
    //                         loading all data from urls
    //============================================================================
    func hasLoggedIn() {
        RetrieveDataFromUrls()
        LoadCachedData()
    }
    
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
    
    func LoadCachedData()
    {
        CacheManager.singleton.ClearCache()
        DispatchQueue.global(qos: .default).async{

            CacheManager.singleton.Load()
            
        }
    }
    
    func SetDisplayMode(mode : DisplayBarListMode)
    {
        barDisplayMode = mode
        
        switch mode {
        case .alphabetical:
            sortByButton.setTitle("Sort by: A-Z", for: .normal)
            
        case .avgRating:
            sortByButton.setTitle("Sort by: Top Rated", for: .normal)
            
        case .priceRating:
            sortByButton.setTitle("Sort by: Best Prices", for: .normal)
            
        case .serviceRating:
            sortByButton.setTitle("Sort by: Best Service", for: .normal)
            
        case .foodRating:
            sortByButton.setTitle("Sort by: Best Food", for: .normal)
            
        case .ambienceRating:
            sortByButton.setTitle("Sort by: Best Ambience", for: .normal)
            
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
                self.collectionView.reloadItems(at: indexPaths)
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
            self.collectionView.reloadData()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        let count = BarManager.singleton.displayBarList.count
        return count
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = BarManager.singleton.displayBarList[section].count
        
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarListCollectionViewCell", for: indexPath) as! BarListCollectionViewCell
        let thisSection = BarManager.singleton.displayBarList[indexPath.section]
        let thisBar = thisSection[indexPath.row]
        
        //set cell display content
        cell.SetContent(bar : thisBar,displayMode: barDisplayMode)
        
        cell.layer.cornerRadius = Sizing.itemCornerRadius
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //prep for display
        BarManager.singleton.DisplayBarDetails(BarManager.singleton.displayBarList[indexPath.section][indexPath.row])
        BarDetailTableViewController.singleton.UpdateDisplays()
        
        self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
        
        BarDetailTableViewController.singleton.ResetToFirstTab()
        
        collectionView.deselectItem(at: indexPath, animated: true)
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
            
            ReviewManager.singleton.ReloadAllReviews()
            
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

    func AddShadow(view : UIView)
    {
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 1.5, height: 4)
        view.clipsToBounds = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
