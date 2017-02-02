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
    
    var refreshButton = UIBarButtonItem()
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    var activityItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.RefreshInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        
        //refresh button
        refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(RefreshInfo))
        self.navigationItem.rightBarButtonItem = refreshButton
        
        //activity indicator
        activityIndicator.color = UIColor.white
        activityIndicator.tintColor = UIColor.white
        activityItem = UIBarButtonItem.init(customView: activityIndicator)

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
            return 4
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
            
        case IndexPath(row: 0, section: 0):
            cell?.textLabel?.text = "Username:"

            
            if Account.singleton.user_name != nil
            {
                cell?.detailTextLabel?.text = "\(Account.singleton.user_name!)"
            }

        case IndexPath(row: 1, section: 0):
            
            cell?.textLabel?.text = "ID:"
            
            if Account.singleton.user_ID != nil
            {
                cell?.detailTextLabel?.text = "\(Account.singleton.user_ID!)"
            }
            
        case IndexPath(row: 2, section: 0):
            cell?.textLabel?.text = "Loyalty Points:"
            
            if Account.singleton.user_loyaltyPts != nil
            {
                cell?.detailTextLabel?.text = "\(Account.singleton.user_loyaltyPts!)"            }
            

        case IndexPath(row: 3, section: 0):
            
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
                
                let window = UIApplication.shared.delegate?.window!!
                window?.rootViewController = LoginViewController.singleton

            })
            
            

        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func RefreshInfo()
    {
        ShowActivityBarButtonItem()
        Account.singleton.RefreshAccountInfo()
        {
                self.HideActivityBarButtonItem()
                self.UpdateTable()
        }
    }
    
    func ShowActivityBarButtonItem()
    {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.navigationItem.rightBarButtonItem = self.activityItem
        }
    }
    
    func HideActivityBarButtonItem()
    {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.refreshButton
        }
    }
    func UpdateTable()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
