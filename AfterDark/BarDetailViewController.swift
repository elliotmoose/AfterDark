//
//  BarDetailViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 17/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailViewController: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.Initialize()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Initialize()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            
        }
        
        //ui init
        dispatch_async(dispatch_get_main_queue()) {
            self.backgroundColor = UIColor.greenColor()
            self.SizingMisc()
        }
    }
    
    func SizingMisc()
    {
        //set frame

    }
}
