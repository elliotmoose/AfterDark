//
//  CategoryDetailCollectionView.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/12/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailCollectionView: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    var collectionView : UICollectionView?
    
    var displayedBarIDs = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //init collection view
        
        //view layout

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Sizing.itemWidth, height: Sizing.itemHeight)
        layout.sectionInset = UIEdgeInsets(top: Sizing.itemInsetFromEdge, left: 0, bottom: Sizing.itemInsetFromEdge, right: 0)
        
        //init collection view
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - Sizing.navBarHeight), collectionViewLayout: layout)
        
        //add collectionview as subview
        self.view.addSubview(collectionView!)
        
        //delegates
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        //colors
        self.collectionView?.backgroundColor = ColorManager.barListBGColor
        
        //register
        DispatchQueue.global(qos: .default).async{
            
            //register bar list collection view cell
            self.collectionView?.register(UINib(nibName: "BarListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BarListCollectionViewCell")
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
        
        self.title = CategoriesManager.singleton.displayedCategory?.name
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return displayedBarIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarListCollectionViewCell", for: indexPath) as! BarListCollectionViewCell
        
        let barID = displayedBarIDs[indexPath.row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        if let thisBar = thisBar
        {
            cell.SetContent(bar : thisBar, displayMode: .alphabetical)
        }
        
        cell.layer.cornerRadius = Sizing.itemCornerRadius
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let barID = displayedBarIDs[indexPath.row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        if let thisBar = thisBar{
            BarManager.singleton.DisplayBarDetails(thisBar)
            BarDetailTableViewController.singleton.UpdateDisplays()
            self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
            BarDetailTableViewController.singleton.ResetToFirstTab()
        }
        else
        {
            NSLog("Cant find bar of ID: \(barID)")
        }
    }
    
}
