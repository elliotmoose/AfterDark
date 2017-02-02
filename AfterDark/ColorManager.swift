import UIKit

class ColorManager
{
    
    //Global Colors
    static let darkGray = UIColor.init(hue: 0, saturation: 0, brightness: 0.15, alpha: 1)
    static let gold = UIColor.init(hue: 41/360, saturation: 0.7, brightness: 0.63, alpha: 1)
    static let textGray = UIColor(hue: 30/360, saturation: 0, brightness: 0.49, alpha: 1)
    static let themeBright = ColorManager.gold
    static let themeGray = ColorManager.textGray
    static let themeDull = UIColor.init(hue: 44/360, saturation: 0.63, brightness: 0.38, alpha: 1)
    
    //Bar List Colors
    static let barListCellIconColor = UIColor.black
    static let barListBGColor = UIColor.gray
    static let barListTitleColor = UIColor.white
    static let barListSortButtonColor = ColorManager.gold
    //Detail View Colors
    static let barIconDefaultColor = UIColor.black
    static let barCellColor = UIColor.darkGray
    
    //gallery colors
    static let galleryBGColor = UIColor.black
    static let galleryPageControlDotHighlightColor = UIColor.white
    static let galleryPageControlDotNormalColor = UIColor.lightGray
    
    //details view
    static let detailTabBGColor = UIColor.black
    static let detailTabDeselectedColor = UIColor.gray
    static let detailTabHighlightedColor = UIColor.white
    static let detailBarTitleColor = UIColor.white
    static let detailViewBGColor = UIColor.black
    
    //description view
    static let descriptionBGColor = UIColor.black
    static let descriptionTitleColor = UIColor.white
    static let descriptionTitleBGColor = ColorManager.darkGray
    static let descriptionIconsTintColor = UIColor.white
    static let descriptionCellBGColor = UIColor.black
    static let descriptionCellTextColor = UIColor.white
    static let reservationCellColor = ColorManager.themeBright
    
    //discount view
    static let discountTableBGColor = UIColor(hue: 0, saturation: 0, brightness: 0.1, alpha: 1)
    static let discountCellTextColor = UIColor.black
    //reviews view
    static let reviewTitleColor = UIColor.white
    static let reviewCellBGColor = UIColor.black
    
    static let ratingStarColor = ColorManager.themeBright
    static let ratingStarBGColor = UIColor.gray
    static let ratingStarLabelTextColor = UIColor.white
    static let expandArrowColor = UIColor.white
    
    //location view
    static let deselectedIconColor = UIColor.darkGray
    static let selectedIconColor = UIColor.init(hue: 217/360, saturation: 0.73, brightness: 0.96, alpha: 1)
    
    //detailed review
    static let placeholderTextColor = UIColor.lightGray
    
    //discount claim view
    static let barHeaderViewColor = UIColor.darkGray
    static let discountTitleBGColor = UIColor.white
    static let discountCellValueTextColor = ColorManager.themeBright
    static let claimButtonColor = ColorManager.themeBright
    static let claimBarTitleTextColor = UIColor.white
    static let discountTitleLabelTextColor = UIColor.white
    static let discountClaimViewBGColor = UIColor.darkGray
    static let descriptionTextViewTextColor = UIColor.lightGray
    
    
    //account creation view
    static let accountCreationHighlightErrorColor = UIColor.red
    
    
    //settings
    static let SettingsImportantCellColor = UIColor(hue: 213/360, saturation: 0.63, brightness: 0.60, alpha: 1)
	init()
	{
        
	}
    
    
}
