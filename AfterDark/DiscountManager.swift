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
    
    var allDiscounts = [Discount]()
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
        
        let urlGetAllDiscounts = Network.domain + "GetAllDiscounts.php"
        Network.singleton.DataFromUrl(urlGetAllDiscounts) { (success, output) in
            
            
            if success
            {
                if let output = output
                {
                    do
                    {
                        
                        if let dictArr = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? [NSDictionary]
                        {
                            self.allDiscounts.removeAll()
                            
                            for dict in dictArr
                            {
                                let newDiscount = Discount(dict: dict)
                                
                                self.allDiscounts.append(newDiscount)
                            }
                            
                            //push discounts into bars
                            self.PushDiscountsIntoBars()
                            
                            
                            DispatchQueue.main.async {
                                //update discount display
                                self.delegate?.UpdateDiscountTab()
                            }
                        }
                    }
                    catch
                    {
                        NSLog("invalid server response")
                    }
                    
                }
                else
                {
                    NSLog("server fault: no response")
                }
            }
            else
            {
                NSLog("Error: check connection")
            }
            
        }
        
        
    }
    
    func PushDiscountsIntoBars()
    {
        //create dictonary where : key = barID value = discountArray
        let outputDict = NSMutableDictionary()
        for discount in allDiscounts
        {
            
            
            guard let barID = discount.bar_ID else {NSLog("discount \(discount.name) has no bar ID");break}
            
            
            //if there is already a key
            if var oldArr = outputDict[barID] as? [Discount]
            {
                oldArr.append(discount)
                outputDict.setValue(oldArr, forKey: barID)
                
            }
            else //if no key set key
            {
                let newArr = [discount]
                outputDict.setValue(newArr, forKey: barID)
            }
        }
        
        
        //for each of the bars in mainBarList -> check if there is [Discount] meant for that bar
        for bar in BarManager.singleton.mainBarList
        {
            if outputDict.contains(where: {$0.key as! String == bar.ID})
            {
                if let discountsArr = outputDict[bar.ID] as? [Discount]
                {
                    bar.discounts = discountsArr
                }
            }
            else
            {
                //NSLog( bar.name + " has no discounts")
            }
            
            //update best discounts
            bar.SetBestDiscount()

        }
        
        //update ui if showing by discount
        
        
    }
    func ClaimDiscount(handler : (_ succuess : Bool)->Void)
    {
        
    }
}
