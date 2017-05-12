//
//  Discount.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 1/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation

class Discount
{
    var name : String?
    var details : String?
    var amount : String?
    var discount_ID : String?
    var bar_ID : String?
    var exclusive = false

    
    init(dict : NSDictionary)
    {
        if let discName = dict["discount_name"] as? String
        {
            name = discName
        }
        if let discDetails = dict["discount_description"] as? String
        {
            details = discDetails
        }
        
        if let discID = dict["discount_ID"] as? Int
        {
            discount_ID = String(describing: discID)
        }
        
        if let barID = dict["Bar_ID"] as? Int
        {
            bar_ID = String(describing: barID)
        }
        
        if let discAmount = dict["discount_amount"] as? String
        {
            amount = discAmount
        }
        
        if let exclusive = dict["Exclusive"] as? Bool
        {
            self.exclusive = exclusive
        }
        
        
    }
    
    init(name : String, details:String , amount : String, discountID : String, bar_ID: String)
    {
        self.name = name
        self.details = details
        self.amount = amount
        self.discount_ID = discountID
        self.bar_ID = bar_ID
    }
}
