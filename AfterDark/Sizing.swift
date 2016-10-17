import Foundation
import UIKit

Class Sizing()
{
    func HundredRelativeWidthPts()->Float
    {
    	return 375/UIScreen.mainScreen.bounds.size.width*100    
    } 

    func HundredRelativeHeightPts()->Float
    {
    	return 667/UIScreen.mainScreen.bounds.size.height*100    
    }

    func ScreenWidth()->Float
    {
        return UIScreen.mainScreen.bounds.size.width
    }

    func ScreenHeight()->Float
    {
        return UIScreen.mainScreen.bounds.size.height
    }
}