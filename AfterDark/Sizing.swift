import Foundation
import UIKit

class Sizing
{
    static let singleton = Sizing()
    class func HundredRelativeWidthPts()->CGFloat
    {
    	return 375/UIScreen.main.bounds.size.width*100
    } 

    class func HundredRelativeHeightPts()->CGFloat
    {
    	return 667/UIScreen.main.bounds.size.height*100
    }

    class func ScreenWidth()->CGFloat
    {
        return UIScreen.main.bounds.size.width
    }

    class func ScreenHeight()->CGFloat
    {
        return UIScreen.main.bounds.size.height
    }

    class func DetailTabViewFrame() ->CGRect{
        let tabHeight = HundredRelativeHeightPts()/3
        let mainViewWidth = ScreenWidth()
        let mainViewHeight = ScreenHeight() - HundredRelativeHeightPts()*2/*gallery min height*/ - 88/*tab bar*/
        
        let detailViewFrame = CGRect(x: 0, y: tabHeight, width: mainViewWidth, height: mainViewHeight - tabHeight )

        return detailViewFrame
    }
    
    class func DetailTabSubViewFrame() ->CGRect{
        let tabHeight = HundredRelativeHeightPts()/3
        let mainViewWidth = ScreenWidth()
        let mainViewHeight = ScreenHeight() - HundredRelativeHeightPts()*2/*gallery min height*/ - 88/*tab bar*/
        
        let detailViewFrame = CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight - tabHeight)
        
        return detailViewFrame
    }
}
