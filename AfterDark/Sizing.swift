import Foundation
import UIKit

class Sizing
{
    
    static let singleton = Sizing()
    
    //bar list
    static let barCellHeight : CGFloat = 90
    static let catTabHeight : CGFloat = 45
    //bar blown up dimensions
    static let minGalleryHeight = Sizing.ScreenHeight()/3
    static let maxGalleryHeight = Sizing.ScreenHeight()/2
    
    static let mainViewHeight = Sizing.ScreenHeight() - Sizing.statusBarHeight - Sizing.navBarHeight - Sizing.catTabHeight - Sizing.barCellHeight - Sizing.tabBarHeight
    static let mainViewHeightWithTabs = Sizing.mainViewHeight + Sizing.tabHeight
    static let mainViewWithoutGalleryAndTabs = Sizing.mainViewHeight - Sizing.tabHeight - Sizing.galleryHeight
    static let tabHeight = Sizing.HundredRelativeHeightPts()/3
    static let blownUpCellHeight = Sizing.mainViewHeight
    static let galleryHeight = Sizing.ScreenHeight()/4
    
    //system dimensions
    static let tabBarHeight : CGFloat = 49
    static let statusBarHeight : CGFloat = 20
    static let navBarHeight : CGFloat = 44
    
    //details view 
    static let detailCellHeight : CGFloat = 50
    
    //discounts
    static let discountCellHeight : CGFloat = 60
    
    //collection view
    static let itemInsetFromEdge : CGFloat = 10
    static let itemWidth = Sizing.ScreenWidth() - itemInsetFromEdge*2
    static let itemHeight = Sizing.ScreenHeight()/2.5
    static let itemCornerRadius: CGFloat = 2.5
    static let sectionHeaderHeight : CGFloat = 40
    
    //reviews view controller
    static let cellUnexpandedHeight : CGFloat = 160 + 53
    static let cellExpansionDiff = Sizing.HundredRelativeHeightPts()*0.8 + 12
    
    //static functions
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

    
}
