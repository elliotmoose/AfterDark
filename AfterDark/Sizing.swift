import Foundation
import UIKit

class Sizing
{
    static let singleton = Sizing()
    class func HundredRelativeWidthPts()->CGFloat
    {
    	return 375/UIScreen.mainScreen().bounds.size.width*100
    } 

    class func HundredRelativeHeightPts()->CGFloat
    {
    	return 667/UIScreen.mainScreen().bounds.size.height*100
    }

    class func ScreenWidth()->CGFloat
    {
        return UIScreen.mainScreen().bounds.size.width
    }

    class func ScreenHeight()->CGFloat
    {
        return UIScreen.mainScreen().bounds.size.height
    }
}