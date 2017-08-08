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
        self.navigationController?.navigationBar.tintColor = ColorManager.themeBright
        self.navigationController?.navigationBar.barTintColor = UIColor.black

        self.navigationController?.navigationBar.isTranslucent = false;
        self.tabBarController?.tabBar.isTranslucent = false;
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
            return 1
        case 1:
            //return 3
            return 2
        case 2:
            return 1
            
        //last section
        case tableView.numberOfSections-1:
            return 3
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
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }

        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = "Account"
            
        case 1:
            if row == 0
            {
                //cell?.textLabel?.text = "Terms"
                cell?.textLabel?.text = "Contact Us"
            }
            else if row == 1
            {
                cell?.textLabel?.text = "Discount Claiming Help"
            }
//            else if row == 2
//            {
//                cell?.textLabel?.text = "Open Source Libraries"
//            }
        
        case 2:
            if row == 0
            {
                cell?.textLabel?.text = "Change Travel Mode: "
                cell?.accessoryType = .none
                cell?.detailTextLabel?.text = "\(Settings.travelMode)"
            }
        
        case tableView.numberOfSections-1:
            if row == 0
            {
                cell?.textLabel?.text = "Share AfterDark"
                cell?.textLabel?.textColor = ColorManager.SettingsImportantCellColor
                cell?.accessoryType = .none
            }
            else if row == 1
            {
                cell?.textLabel?.text = "Clear Cache"
                cell?.textLabel?.textColor = ColorManager.SettingsImportantCellColor
                cell?.accessoryType = .none
            }
            else if row == 2
            {
                cell?.textLabel?.text = "Log Out"
                cell?.textLabel?.textColor = ColorManager.SettingsImportantCellColor
                cell?.accessoryType = .none
            }

        default:
            break
        }
        
        return cell!
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row

        switch indexPath.section {
            
        case 0:
            if row == 0
            {
                self.navigationController?.pushViewController(AccountTableViewController.singleton, animated: true)
            }
        case 1:
            if row == 0
            {
//                self.navigationController?.pushViewController(DisplayTextViewController.singleton, animated: true)
//                //DisplayTextViewController.singleton.SetText(title: "Terms Of Use", body: "test1")
//                DisplayTextViewController.singleton.SetText(title: "Contact Us:)", body: "Feel free to contact us afterdarkbars@gmail.com for any enquiries or to report any issues!")
//                DisplayTextViewController.singleton.SetTextAlignment(.center)
                
                self.navigationController?.pushViewController(ContactUsViewController.singleton, animated: true)
            }
            else if row == 1
            {
                self.navigationController?.pushViewController(DisplayTextViewController.singleton, animated: true)
                //DisplayTextViewController.singleton.bodyTextView.textAlignment = .center
                DisplayTextViewController.singleton.SetText(title: "Claiming of discounts", body: "Step 1:\nCheck with the staff if the discount is valid before your meal \n\nStep 2:\nUpon payment of drinks, select the desired discount and enter in the Final Receipt Value \n\nStep 3:\nStaff to ensure receipt value is accurate before keying in their 4-Digit Pin \n\nStep 4:\nEnjoy your discount along with loyalty points*! \n\n\n\n\n\n*loyalty points may be used to claim discounts in the future")

            }
            else if row == 2
            {
                self.navigationController?.pushViewController(DisplayTextViewController.singleton, animated: true)
                DisplayTextViewController.singleton.SetText(title: "Open Source Libraries", body: "test3")

            }
        case 2:
            if row == 0
            {
                switch Settings.travelMode {
                case .Walk:
                    Settings.travelMode = .Transit
                case .Transit:
                    Settings.travelMode = .Drive
                case .Drive:
                    Settings.travelMode = .Walk
                }
                
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        case tableView.numberOfSections-1:
            if row == 0
            {
                
                //https://itunes.apple.com/app/id1181931586

                //let url = URL(fileURLWithPath: "https://itunes.apple.com/sg/app/apple-store/id1181931586?mt=8")
                let vc = UIActivityViewController(activityItems: ["https://itunes.apple.com/app/id1181931586 \n Check out this cool app that helps me get epic discounts at bars!"], applicationActivities: [])
                    present(vc, animated: true)
            }
            else if row == 1
            {
                //clear cache
                CacheManager.singleton.ClearCache()
                PopupManager.singleton.Popup(title: "Done!", body: "Cache has been cleared!", presentationViewCont: self)
            }
            else if row == 2
            {
                PopupManager.singleton.PopupWithCancel(title: "Log Out", body: "Are you sure you want to log out?", presentationViewCont: self, handler: {
                    
                    //logout and reload account view
                    Account.singleton.LogOut()
                    
                    let window = UIApplication.shared.delegate?.window!!
                    window?.rootViewController = LoginViewController.singleton
                    
                })
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
