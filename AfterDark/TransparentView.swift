//
//  TransparentView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class TransparentView: UIView {
    var pageView: GalleryViewController?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    //============================================================================
    //                                 override to only select visible header
    //============================================================================
    
    
//    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
//    {
//
//            if pageView!.view.pointInside(convertPoint(point, toView: pageView!.view), withEvent: event) {
//                return true
//            }
//
//        return false
//
//        
//    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView == self
        {
            return pageView?.view
        }
        else
        {
            return hitView
        }
        
    }
}
