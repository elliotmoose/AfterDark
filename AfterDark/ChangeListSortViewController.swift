//
//  ChangeListSortViewController.swift
//  
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 30/11/16.
//
//

import UIKit

class ChangeListSortViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    static let singleton = ChangeListSortViewController(nibName: "ChangeListSortViewController", bundle: Bundle.main)
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //init for this view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //0: A-Z
        //1: Rating - Avg
        //2: Rating - Price
        //3: Rating - Food
        //4: Rating - Service
        //5: Rating - Ambience
        //drinks?
        
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var title = "";
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            title = "A-Z"
            
        case IndexPath(row: 1, section: 0):
            title = "Rating - Average"
            
        case IndexPath(row: 2, section: 0):
            title = "Rating - Price"
        case IndexPath(row: 3, section: 0):
            title = "Rating - Food"
        case IndexPath(row: 4, section: 0):
            title = "Rating - Service"
        case IndexPath(row: 5, section: 0):
            title = "Rating - Ambience"
            
        default:
            title = "oops"
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: title)
        
        if cell == nil
        {
            cell = UITableViewCell()
        }
        
        cell!.textLabel?.text = title
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            BarManager.singleton.ArrangeBarList(.alphabetical)
        case IndexPath(row: 1, section: 0):
            BarManager.singleton.ArrangeBarList(.alphabetical)

        case IndexPath(row: 2, section: 0):
            BarManager.singleton.ArrangeBarList(.alphabetical)

        case IndexPath(row: 3, section: 0):
            BarManager.singleton.ArrangeBarList(.alphabetical)

        case IndexPath(row: 4, section: 0):
            BarManager.singleton.ArrangeBarList(.alphabetical)

        case IndexPath(row: 5, section: 0):
            BarManager.singleton.ArrangeBarList(.alphabetical)

            
        default:
            title = "oops"
        }

    }

}
