//
//  CategoryDetailView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 29/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailView: UITableViewController {

    var displayedBars = [Bar]()
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
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
        return displayedBars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarListTableViewCell", for: indexPath) as! BarListTableViewCell

        let thisBar = displayedBars[indexPath.row]
        cell.SetContent(thisBar.icon, barName: thisBar.name, barRating: thisBar.rating)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        BarManager.singleton.DisplayBarDetails(displayedBars[row])
        self.navigationController?.pushViewController(BarDetailTableViewController.singleton, animated: true)
    }
    

 
}
