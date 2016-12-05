//
//  CategoryDetailView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailView: UITableViewController {

    var displayedBarIDs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        DispatchQueue.global(qos: .default).async{
            
            //register bar list table view cell
            self.tableView.register(UINib(nibName: "BarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BarListTableViewCell")
            
            self.tableView.rowHeight = 85
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedBarIDs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarListCollectionViewCell", for: indexPath) as! BarListCollectionViewCell

        let barID = displayedBarIDs[indexPath.row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        if let thisBar = thisBar
        {
            cell.SetContent(thisBar.icon, barName: thisBar.name, barRating: thisBar.rating, displayMode: .alphabetical)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let barID = displayedBarIDs[indexPath.row]
        let thisBar = BarManager.singleton.BarFromBarID(barID)
        
        if let thisBar = thisBar{
            BarManager.singleton.DisplayBarDetails(thisBar)
            BarDetailTableViewController.singleton.UpdateDisplays()
            self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
        }
        else
        {
            NSLog("Cant find bar of ID: \(barID)")
        }
        
        
    }
    

 
}
