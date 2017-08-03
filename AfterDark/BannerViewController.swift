//
//  BannerViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 24/7/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BannerManagerDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshButton = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "bannerTableViewCell")
        
        BannerManager.singleton.delegate = self
        
        
        //navigation bar and tab bar init
        //nav bar and tab bar translucency for framing purposes
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        
        //colors
        self.navigationController?.navigationBar.tintColor = ColorManager.themeBright
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black;
        self.tabBarController?.tabBar.tintColor = ColorManager.themeBright
        
        self.tableView.backgroundColor = ColorManager.discountTableBGColor
        tableView?.tableFooterView = UIView() //remove seperator lines
        
        self.title = "Featured Discounts"
        
        
        refreshButton = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(Refresh))
        refreshButton.tintColor = ColorManager.themeBright
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
        activityIndicator.startAnimating()
        
        self.navigationItem.rightBarButtonItem = refreshButton
        
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BannerManager.singleton.banners.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bannerTableViewCell", for: indexPath) as? BannerTableViewCell
        {
            cell.banner = BannerManager.singleton.banners[indexPath.row]
            cell.UpdateDisplay()
            
            return cell
        }
        else
        {
            NSLog("CANT DEQUEUE")
            return BannerTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //navigate to that specific bar

        if indexPath.row > BannerManager.singleton.banners.count
        {
            return
        }
        
        let banner = BannerManager.singleton.banners[indexPath.row]
        guard let bar = BarManager.singleton.BarFromBarID(banner.barID) else {return}
        guard let discount = DiscountManager.singleton.DiscountFromDiscountID(banner.discountID) else {return}
        
        DiscountDetailViewController.singleton.Load(bar: bar, discount: discount)
        self.navigationController?.pushViewController(DiscountDetailViewController.singleton, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180;
    }

    func BannerTextLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func BannerImageLoadedAtIndex(index: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func Refresh()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        //load discounts
        DiscountManager.singleton.LoadAllDiscounts()
            {
                //load banners
                BannerManager.singleton.LoadBannerText({ (success) in
                    if success
                    {
                        BannerManager.singleton.LoadBannerImages()
                        
                        DispatchQueue.main.async {
                            self.navigationItem.rightBarButtonItem = self.refreshButton
                        }
                    }
                })
        }

    }

    
    
}
