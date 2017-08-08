//
//  DiscountViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit
import Foundation

protocol DiscountToMainCellDelegate : class {
    func PushViewController(viewCont : UIViewController)
}


class DiscountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var tableView: UITableView?
    
    weak var delegate : DiscountToMainCellDelegate?
    
    let discountDetailViewCont = DiscountDetailViewController(nibName: "DiscountDetailViewController", bundle: Bundle.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        
    }
    
    override func awakeFromNib() {
        
    }
    func Initialize()
    {
        //frames
        let mainViewHeight = Sizing.mainViewHeight
        tableView = UITableView(frame: CGRect(x: 0, y: 0,width: Sizing.ScreenWidth(),height: mainViewHeight))
        self.tableView?.rowHeight = Sizing.discountCellHeight

        //color
        
        tableView?.backgroundColor = ColorManager.discountTableBGColor
        tableView?.separatorColor = UIColor.clear
        
        //delegates
        tableView?.dataSource = self
        tableView?.delegate = self
        
        self.view.addSubview(tableView!)

        tableView?.register(UINib(nibName: "DiscountCell", bundle: Bundle.main), forCellReuseIdentifier: "DiscountCell")

        
    }
    
    override func viewDidAppear(_ animated: Bool) {


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //reset this navigation controller to the intiial page
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bar = BarManager.singleton.displayedDetailBar
        {
            return bar.discounts.count
        }
        else
        {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCell", for: indexPath) as? DiscountCell
        
        if cell == nil{
            cell = DiscountCell()
        }
        
        if let bar = BarManager.singleton.displayedDetailBar
        {
            cell?.Load(discount: bar.discounts[indexPath.row])
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if let bar = BarManager.singleton.displayedDetailBar
        {
            discountDetailViewCont.Load(bar: bar, discount: bar.discounts[row])
        }
        self.delegate?.PushViewController(viewCont: discountDetailViewCont)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
