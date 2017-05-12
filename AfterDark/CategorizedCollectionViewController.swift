//
//  CategorizedCollectionViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 28/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategorizedCollectionViewController: UICollectionViewController,CategoryManagerDelegate,BarManagerToListTableDelegate {
    
    internal func UpdateCellForBar(_ bar: Bar) {
        
    }


    //let categoryCollectionViewCont = CategoryDetailCollectionView()
    let barListTableViewController = CategoryDetailTableViewController()
    
    
    var refreshButton = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        self.collectionView!.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCell")
        
        
        CategoriesManager.singleton.delegate = self
        BarManager.singleton.catListDelegate = self

        self.title = "HOME"
        
        //navigation controller
        self.navigationController?.navigationBar.barStyle = .black;
        self.navigationController?.navigationBar.tintColor = ColorManager.themeBright
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.5, height: 3.5)
        view.clipsToBounds = false

        self.tabBarController?.tabBar.layer.shadowOpacity = 0.2
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.white.cgColor
        self.tabBarController?.tabBar.clipsToBounds = false
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        
        refreshButton = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(Refresh))
        refreshButton.tintColor = ColorManager.themeBright
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
        activityIndicator.startAnimating()
        
        self.navigationItem.rightBarButtonItem = refreshButton

    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        CategoriesManager.singleton.displayedCategory = nil
        collectionView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoriesManager.singleton.displayedCategories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell",for: indexPath) as? CategoryCell
        
        cell!.SetContent(CategoriesManager.singleton.displayedCategories[indexPath.row])
        
        return cell!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//        //update bars to display
//        categoryCollectionViewCont.displayedBarIDs = CategoriesManager.singleton.allCategories[indexPath.row].barIDs
//        
//        //update selected category (for navigation title)
//        CategoriesManager.singleton.displayedCategory = CategoriesManager.singleton.allCategories[indexPath.row]
//        
//        //push category detail
//        self.navigationController?.pushViewController(categoryCollectionViewCont, animated: true)
        
        //update bars to display
        barListTableViewController.toBeDisplayedBarIDs = CategoriesManager.singleton.displayedCategories[indexPath.row].barIDs
        
        //update selected category (for navigation title)
        CategoriesManager.singleton.displayedCategory = CategoriesManager.singleton.displayedCategories[indexPath.row]
        
        //push view controller
        self.navigationController?.pushViewController(barListTableViewController, animated: true)
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
     
        return CGSize(width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight()/4)
    }
    
    func ReloadCategoriesView()
    {
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
    }
    
    func ReloadCell(index: Int)
    {
        if (collectionView?.numberOfItems(inSection: 0))! < index+1
        {
            return
        }
        //reloads by index
        collectionView?.reloadItems(at: [IndexPath(row: index ,section:0)])
        
    }
    
    func Refresh()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        CategoriesManager.singleton.SoftLoadAllCategories()
        {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = self.refreshButton
            }
        }
    }
    
    
    func UpdateBarListTableDisplay() {
        
        barListTableViewController.SetBarIDs(barIDs: barListTableViewController.toBeDisplayedBarIDs)
        
    }

}
