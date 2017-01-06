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
        self.navigationController?.navigationBar.barStyle = .black;
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barTintColor = UIColor.black

        self.navigationController?.navigationBar.isTranslucent = false;
        self.tabBarController?.tabBar.isTranslucent = false;
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
            
        //last section
        case tableView.numberOfSections-1:
            return 2
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Account"
        case 1:
            return "About"
        default:
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let row = indexPath.row
        if cell == nil
        {
            cell = UITableViewCell()
            cell?.accessoryType = .disclosureIndicator
        }

        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = "Account"
            
        case 1:
            if row == 0
            {
                cell?.textLabel?.text = "Terms"
            }
            else if row == 1
            {
                cell?.textLabel?.text = "Privacy Policy"
            }
            else if row == 2
            {
                cell?.textLabel?.text = "Open Source Libraries"
            }
        
        case tableView.numberOfSections-1:
            if row == 0
            {
                cell?.textLabel?.text = "Clear Cache"
                cell?.textLabel?.textColor = ColorManager.SettingsImportantCellColor
            }
            else if row == 1
            {
                cell?.textLabel?.text = "Log Out"
                cell?.textLabel?.textColor = ColorManager.SettingsImportantCellColor

            }

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
