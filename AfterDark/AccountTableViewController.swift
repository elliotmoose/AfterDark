//
//  AccountTableViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    
    static let singleton = AccountTableViewController(nibName: "AccountTableViewController", bundle: Bundle.main)
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0
        {
            return 3
        }
        else if section == 1
        {
            return 2
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Account Info"
        }
        else
        {
            return "Manage Account"
        }
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil{
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.detailTextLabel?.textColor = UIColor.black
        }

        switch indexPath {
        case IndexPath(row: 1, section: 0):
            
            cell?.textLabel?.text = "ID:"

            if Account.singleton.user_ID != nil
            {
                cell?.detailTextLabel?.text = "\(Account.singleton.user_ID!)"
            }
            
            
        case IndexPath(row: 0, section: 0):
            cell?.textLabel?.text = "Username:"

            
            if Account.singleton.user_name != nil
            {
                cell?.detailTextLabel?.text = "\(Account.singleton.user_name!)"
            }

        case IndexPath(row: 2, section: 0):
            
            cell?.textLabel?.text = "Email:"

            if Account.singleton.user_Email != nil
            {
                cell?.detailTextLabel?.text = "\(Account.singleton.user_Email!)"
            }
        case IndexPath(row: 0, section: 1):
            
            cell?.textLabel?.text = "Change Password"
            cell?.accessoryType = .disclosureIndicator
            
        case IndexPath(row: 1, section: 1):
            
            cell?.textLabel?.text = "Log Out"
            cell?.accessoryType = .disclosureIndicator
        
        default:
            break
        }

        return cell!
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
            
            //change pass
        case IndexPath(row: 0, section: 1):
            self.navigationController?.pushViewController(ChangePasswordViewController.singleton, animated: true)
            break
            
            //log out
        case IndexPath(row: 1, section: 1):
            

            
            //must change back to bar list view
            PopupManager.singleton.PopupWithCancel(title: "Log Out", body: "Are you sure you want to log out?", presentationViewCont: self, handler: {
            
                //logout and reload account view
                Account.singleton.LogOut()
                self.tableView.reloadData()
                
                //reset app to login page
                self.tabBarController?.selectedIndex = 1;
                self.tabBarController?.viewControllers?[1].present(LoginViewController.singleton, animated: true, completion: nil)
            })
            
            

        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
