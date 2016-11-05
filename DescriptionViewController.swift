//
//  DescriptionTableViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
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
    
        let tableViewBackGroundColor = ColorManager.descriptionCellBGColor
        tableView?.backgroundColor = tableViewBackGroundColor
        
        self.view.addSubview(tableView!)

        tableView?.dataSource = self
        tableView?.delegate = self
        
        //register nibs
        //self.tableView!.registerClass(DescriptionCell.self, forCellReuseIdentifier: "DecsriptionCell") IconCell
        self.tableView!.register(UINib(nibName: "DescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "DescriptionCell")
        self.tableView!.register(UINib(nibName: "IconCell", bundle: Bundle.main), forCellReuseIdentifier: "IconCell")
        self.tableView!.register(UINib(nibName: "OpeningHoursCell", bundle: Bundle.main), forCellReuseIdentifier: "OpeningHoursCell")
       
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if BarManager.singleton.displayedDetailBar.bookingAvailable == "1"
        {
            return 6
        }
        
        return 5
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")

        switch indexPath
        {
        case IndexPath(row: 0, section: 0):
        
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: IndexPath(row: 0, section: 0)) as! DescriptionCell
            descriptionCell.descriptionBodyLabel.text = BarManager.singleton.displayedDetailBar.description
            descriptionCell.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.HundredRelativeHeightPts()*1.5)
            descriptionCell.selectionStyle = .none
            descriptionCell.descriptionBodyLabel.textColor = ColorManager.descriptionCellTextColor
            descriptionCell.descriptionTitle.textColor = ColorManager.descriptionCellTextColor
            descriptionCell.backgroundColor = ColorManager.descriptionCellBGColor
            return descriptionCell
        case IndexPath(row: 1, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: IndexPath(row: 1, section: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Marker-48")?.withRenderingMode(.alwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            
            return cell!
        case  IndexPath(row: 2, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursCell", for: IndexPath(row: 2, section: 0)) as? OpeningHoursCell
            if cell == nil
            {
                cell = OpeningHoursCell()
                
                
            }
            
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Clock-48")?.withRenderingMode(.alwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            cell?.selectionStyle = .none
            if BarManager.singleton.displayedDetailBar.openClosingHours == nil
            {
                BarManager.singleton.displayedDetailBar.openClosingHours = "Unknown"
            }
            
            cell?.Detail.text = BarManager.singleton.displayedDetailBar.openClosingHours
            
            openingHoursCell = cell!
            return cell!

        case IndexPath(row: 3, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: IndexPath(row: 3, section: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Phone-48")?.withRenderingMode(.alwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            cell?.Detail.text = BarManager.singleton.displayedDetailBar.contact
            cell?.selectionStyle = .none
            return cell!

        case IndexPath(row: 4, section: 0):
            var cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: IndexPath(row: 3, section: 0)) as? IconCell
            if cell == nil
            {
                cell = IconCell()


            }
            
            cell?.backgroundColor = ColorManager.descriptionCellBGColor
            cell?.Detail.textColor = ColorManager.descriptionCellTextColor
            cell?.Icon?.image = UIImage(named: "Domain Filled-50")?.withRenderingMode(.alwaysTemplate)
            cell?.Icon?.tintColor = ColorManager.descriptionIconsTintColor
            cell?.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
            cell?.selectionStyle = .none

            return cell!

        case IndexPath(row: 5, section: 0):
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell")
            if cell == nil{
                cell = UITableViewCell()
                cell?.textLabel?.text = "Make Reservation"
                cell?.backgroundColor = ColorManager.reservationCellColor
                cell?.accessoryType = .disclosureIndicator
            }
            
            
            
            return cell!
        default: cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        }

        return cell!
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath
        {
        case IndexPath(row: 0, section: 0):
            return Sizing.HundredRelativeHeightPts()*1.5
        default: return 70
        }
        
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 && openingHoursCell != nil
        {
            let thisCell = openingHoursCell
            if thisCell!.isExpanded
            {
                //collapse
                thisCell!.isExpanded = false
                thisCell!.CollapseCell()
            }
            else
            {
                //expand
                thisCell!.isExpanded = true
                thisCell!.ExpandCell()
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        //make reservation cell
        if indexPath.row == 5
        {
            BarDetailTableViewController.singleton.navigationController?.pushViewController(ReservationViewController.singleton, animated: true)
        }
        


    }



    
}
