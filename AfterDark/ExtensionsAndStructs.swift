//
//  ExtensionsAndStructs.swift
//  AfterDark Merchant
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 16/12/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

import Foundation
import UIKit
extension String{
    public func AddPercentEncodingForURL(plusForSpace : Bool = false) -> String?
    {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace
        {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        
        if plusForSpace
        {
            encoded = encoded?.replacingOccurrences(of: " ", with: "%20")
        }
        
        
        
        return encoded
        
    }
}

extension UIImage
{
    public func newImageWithSize(_ size : CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
