//
//  CategorizedCollectionViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 28/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategorizedCollectionViewController: UICollectionViewController,CategoryManagerDelegate {

    let categoryCollectionViewCont = CategoryDetailCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCell")
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        CategoriesManager.singleton.delegate = self
        
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func ReloadCategoriesView()
    {
        DispatchQueue.main.async(execute: {
        self.collectionView?.reloadData()
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoriesManager.singleton.allCategories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell",for: indexPath) as? CategoryCell
    
        cell!.SetContent(CategoriesManager.singleton.allCategories[indexPath.row])
        
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

        categoryCollectionViewCont.displayedBarIDs = CategoriesManager.singleton.allCategories[indexPath.row].barIDs
        BarDetailTableViewController.singleton.UpdateDisplays()
        self.navigationController?.pushViewController(categoryCollectionViewCont, animated: true)
        
    }

    

}
