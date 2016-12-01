//
//  SettingsTableViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false;
        self.tabBarController?.tabBar.isTranslucent = false;
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell()
            cell?.accessoryType = .disclosureIndicator
        }

        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell?.textLabel?.text = "Account"
        default:
            break
        }
        
        return cell!
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            self.navigationController?.pushViewController(AccountTableViewController.singleton, animated: true)
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
