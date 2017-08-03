//
//  Banner.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 24/7/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import Foundation
import UIKit

class Banner
{
    public var image : UIImage?
    public var title = ""
    public var description = ""
    public var barID = ""
    public var discountID = ""
    
    
    init(dict : NSDictionary) {
        
       
        
        if let discountID = dict["discountID"] as? String
        {
            self.discountID = discountID
        }
        else if let discountID = dict["discountID"] as? Int
        {
            self.discountID = "\(discountID)"
        }
        
        if let barID = dict["Bar_ID"] as? String
        {
            self.barID = barID
        }
        else if let barID = dict["Bar_ID"] as? Int
        {
            self.barID = "\(barID)"
        }
        
        if let bar = BarManager.singleton.BarFromBarID(barID)
        {
            self.description = bar.name
        }
        
        if let title = dict["name"] as? String
        {
            if title == "default"
            {
                if let name =  DiscountManager.singleton.DiscountFromDiscountID(discountID)?.name
                {
                    self.title = name
                }
            }
            else
            {
                self.title = title
            }
        }
        
    }
}
