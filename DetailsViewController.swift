//
//  DescriptionTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    var openingHoursCell : OpeningHoursCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()

    }

    func Initialize()
    {
       

        

        let mainViewHeight = Sizing.mainViewHeight
        tableView = UITableView(frame: CGRect(x: 0, y: 0,width: Sizing.ScreenWidth(),height: mainViewHeight))
        tableView?.contentInset = UIEdgeInsetsMake((Sizing.mainViewWithoutGalleryAndTabs - 3*Sizing.detailCellHeight)/2, 0, 0, 0)
        
        let tableViewBackGroundColor = ColorManager.descriptionCellBGColor
        tableView?.backgroundColor = tableViewBackGroundColor
        tableView?.separatorColor = UIColor.clear
        
        self.view.addSubview(tableView!)

        tableView?.dataSource = self
        tableView?.delegate = self
        
        self.tableView!.register(UINib(nibName: "IconCell", bundle: Bundle.main), forCellReuseIdentifier: "IconCell")
        self.tableView!.register(UINib(nibName: "OpeningHoursCell", bundle: Bundle.main), forCellReuseIdentifier: "OpeningHoursCell")
        
        
        
       
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if BarManager.singleton.displayedDetailBar != nil && BarManager.singleton.displayedDetailBar!.bookingAvailable == "1"
//        {
//            return 4
//        }
//        
        return 3
    }


//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0
//        {
//            return "Description"
//        }
//        else
//        {
//            return ""
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let headerView = view as! UITableViewHeaderFooterView
//        headerView.textLabel?.textColor = ColorManager.descriptionTitleColor
//        headerView.textLabel?.font = UIFont(name: "Mohave", size: 20)
//        headerView.tintColor = ColorManager.descriptionTitleBGColor
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        guard BarManager.singleton.displayedDetailBar != nil else {return tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)}
        
        switch indexPath
        {
//        case IndexPath(row: 0, section: 0):
//        
//            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: IndexPath(row: 0, section: 0)) as! DescriptionCell
//            
//            descriptionCell.textLabel?.text = BarManager.singleton.displayedDetailBar?.description
//            descriptionCell.textLabel?.numberOfLines = 0
//            descriptionCell.selectionStyle = .none
//            
//            //colors
//            descriptionCell.textLabel?.textColor = ColorManager.descriptionCellTextColor
//            descriptionCell.backgroundColor = ColorManager.descriptionCellBGColor
//            
//            return descriptionCell
            
        case IndexPath(row: 0, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: IndexPath(row: 0, section: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }

            cell?.Icon?.image = UIImage(named: "Marker-48")?.withRenderingMode(.alwaysTemplate)
            if BarManager.singleton.displayedDetailBar != nil && BarManager.singleton.displayedDetailBar!.address != ""
            {
                cell?.Detail.text = BarManager.singleton.displayedDetailBar!.address
            }
            else
            {
                cell?.Detail.text = "no address given"
            }
            
            return cell!
        case  IndexPath(row: 1, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursCell", for: IndexPath(row: 1, section: 0)) as? OpeningHoursCell
            if cell == nil
            {
                cell = OpeningHoursCell()
            }
            
            cell?.LoadOpeningHours(openingHours: BarManager.singleton.displayedDetailBar!.openClosingHours)
            openingHoursCell = cell!
            
            return cell!

        case IndexPath(row: 2, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: IndexPath(row: 2, section: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()
            }
            
           
            cell?.Icon?.image = UIImage(named: "Phone-48")?.withRenderingMode(.alwaysTemplate)
            cell?.Detail.text = BarManager.singleton.displayedDetailBar?.contact
            return cell!

        case IndexPath(row: 3, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: IndexPath(row: 3, section: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            
            cell?.Icon?.image = UIImage(named: "Domain Filled-50")?.withRenderingMode(.alwaysTemplate)
            cell?.Detail.text = BarManager.singleton.displayedDetailBar?.website
            

            return cell!

//        case IndexPath(row: 4, section: 0):
//            
//            cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell")
//            if cell == nil{
//                cell = UITableViewCell()
//                cell?.textLabel?.text = "Make Reservation"
//                cell?.textLabel?.font = UIFont(name: "Montserrat-Bold", size: 17)
//                cell?.backgroundColor = ColorManager.reservationCellColor
//                cell?.accessoryType = .disclosureIndicator
//            }
//            
            
            
            return cell!
        default: cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        }

        return cell!
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
  
        switch indexPath
        {

        case IndexPath(row: 1, section : 0):
            
            if openingHoursCell != nil
            {
                if (openingHoursCell?.isExpanded)!
                {
                    return 240
                }
                else
                {
                    return Sizing.detailCellHeight
                }

            }
            else
            {
                return Sizing.detailCellHeight
            }
        default: return Sizing.detailCellHeight
        }
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath
        {

        case IndexPath(row: 1, section : 0):
            
            if openingHoursCell != nil
            {
                if (openingHoursCell?.isExpanded)!
                {
                    return 240
                }
                else
                {
                    return Sizing.detailCellHeight
                }
                
            }
            else
            {
                return Sizing.detailCellHeight
            }
        default: return Sizing.detailCellHeight
        }
        
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let _ = BarManager.singleton.displayedDetailBar else {return}
        
        if indexPath.row == 1 && openingHoursCell != nil
        {
            
            if openingHoursCell!.isExpanded
            {
                //collapse
                openingHoursCell!.isExpanded = false
                openingHoursCell!.CollapseCell()
            }
            else
            {
                //expand
                openingHoursCell!.isExpanded = true
                openingHoursCell!.ExpandCell()
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()

        }
        
        if indexPath.row == 2
        {
            let phonenumber = BarManager.singleton.displayedDetailBar?.contact
            if let url = URL(string: "tel://\(phonenumber)")
            {
                if UIApplication.shared.canOpenURL(url)
                {
                    UIApplication.shared.openURL(url)
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath.row == 3
        {
            if let url = URL(string: BarManager.singleton.displayedDetailBar!.website)
            {
                if UIApplication.shared.canOpenURL(url)
                {
                    UIApplication.shared.openURL(url)
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
        

    }

    


    
}
