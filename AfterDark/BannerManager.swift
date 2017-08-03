//
//  BannerManager.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 24/7/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import Foundation
import UIKit

protocol BannerManagerDelegate : class
{
    func BannerTextLoaded()
    func BannerImageLoadedAtIndex(index : Int)
}

class BannerManager
{
    public static let singleton = BannerManager();
    
    public var banners = [Banner]()
    
    public weak var delegate : BannerManagerDelegate?
    
    init()
    {
        
    }
    
    public func LoadBannerText(_ handler: @escaping (Bool)-> Void)
    {
        Network.singleton.DataFromUrl(Network.domain + "GetBannerTexts.php") {(success, output) in
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                        {
                            
                            if let succ = dict["success"] as? String
                            {
                                if succ == "true"
                                {
                                    if let bannerDicts = dict["detail"] as? [NSDictionary]
                                    {
                                        self.banners.removeAll()
                                        
                                        for bannerDict in bannerDicts
                                        {
                                            let banner = Banner(dict : bannerDict)
                                            self.banners.append(banner)
                                        }
                                        
                                        self.delegate?.BannerTextLoaded()
                                        handler(true)
                                        return
                                    }
                                    else
                                    {
                                        NSLog("invalid server response 1")
                                    }
                                }
                                else
                                {
                                    if let detail = dict["detail"] as? String
                                    {
                                        NSLog(detail)
                                    }
                                }
                            }
                            else
                            {
                                NSLog("invalid server response 2")
                            }
                        }
                        else
                        {
                            NSLog("invalid server response 3")
                        }
                    }
                    catch _ as NSError
                    {
                        NSLog("invalid server response 4")
                    }
                }
                else
                {
                    NSLog("server fault: no response")
                }
                
            }
            
            NSLog("failed to load banner text")
            handler(false)

        }
    }
    
    public func LoadBannerImages()
    {
        for i in 0 ..< banners.count
        {
            let banner = banners[i]
            
            LoadImageForBanner(banner)
            {
                DispatchQueue.main.async {
                    self.delegate?.BannerImageLoadedAtIndex(index: i)
                }
            }
        }
    }
    
    private func LoadImageForBanner(_ banner : Banner,  _ handler: @escaping ()->Void)
    {
        let url = Network.domain + "Banner_Images/\(banner.discountID).jpg"
        Network.singleton.DataFromUrl(url) { (success, output) in
            if success
            {
                if let output = output
                {
                    if let image = UIImage(data: output)
                    {
                        banner.image = image
                        handler()
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    NSLog("server fault: no response")
                }
                
            }
            
        }
    }
}
