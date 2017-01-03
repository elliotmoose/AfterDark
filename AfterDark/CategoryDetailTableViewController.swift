//
//  CategoryDetailTableViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    
    var displayedBarIDs = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //init tableView
        tableView = UITableView(frame: view.frame)
        self.view.addSubview(tableView!)
        
        //register cell
        tableView?.register(UINib(nibName: "CategoryTableCell", bundle: Bundle.main), forCellReuseIdentifier: "CategoryTableCell")
        
        
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedBarIDs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath) as! CategoryTableCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}
