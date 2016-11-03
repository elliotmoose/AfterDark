//
//  DiscountManager.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 1/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import Foundation

protocol DiscountManagerToDetailTableDelegate : class
{
    func UpdateDiscountTab()
}

class DiscountManager
{
    static let singleton = DiscountManager()
    weak var delegate : DiscountManagerToDetailTableDelegate?
    
//    func LoadDiscount(_ bar : Bar,handler:@escaping (_ success: Bool)-> Void)
//    {
//        let urlGetDiscountsForBar = "http://mooselliot.net23.net/GetBarDiscounts.php?Bar_ID=\(bar.ID)"
//        Network.singleton.DictArrayFromUrl(urlGetDiscountsForBar, handler: {
//        success,output -> Void in
//            if success{
//                
//                //add discount to bar
//                
//                
//                handler(true)
//            }
//        })
//    }
    
    func LoadAllDiscounts()
    {
        let urlGetAllDiscounts = "http://mooselliot.net23.net/GetAllDiscounts.php"
        Network.singleton.DictArrayFromUrl(urlGetAllDiscounts, handler: {(success,output)
        in
            if success
            {
                if (output as Any) is [NSDictionary]
                {
                    for dict in output{
                        let newDiscount = Discount(dict: dict)
                        
                        //add the loaded discount to its respective bar
                        BarManager.singleton.BarFromBarID(newDiscount.bar_ID!)?.discounts.append(newDiscount)
                        
                        //update discount display
                        self.delegate?.UpdateDiscountTab()
                        
                    }
                }
            }
        })

    }
    
    func ClaimDiscount(handler : (_ succuess : Bool)->Void)
    {
        
    }
}
