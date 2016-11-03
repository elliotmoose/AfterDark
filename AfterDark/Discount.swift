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

    init(dict : NSDictionary)
    {
        name = dict["discount_name"] as? String
        details = dict["discount_description"] as? String
        discount_ID = dict["discount_ID"] as? String
        bar_ID = dict["Bar_ID"] as? String
        amount = dict["discount_amount"] as? String
    }
    
}
