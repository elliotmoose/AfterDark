//
//  BarDetailHeaderView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 18/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailViewMainCell: UITableViewCell {

    var barIconImageView :UIImageView
    var tab1 : UIButton
    var tab2 : UIButton
    var tab3 : UIButton
    var tab4 : UIButton
    var mainDetailView : UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Initialize()
    
    }

    required init?(coder aDecoder: NSCoder) {
        barIconImageView = UIImageView.init(frame: CGRectMake(0,0,0,0))
        tab1 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab2 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab3 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab4 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        mainDetailView = UIView.init(frame: CGRectMake(0, 0, 0, 0))
        super.init(coder: aDecoder)

    }

    init(frame: CGRect)
    {
        barIconImageView = UIImageView.init(frame: CGRectMake(0,0,0,0))
        tab1 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab2 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab3 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab4 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        mainDetailView = UIView.init(frame: CGRectMake(0, 0, 0, 0))
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "BarDetailHeaderView")
        self.frame = frame
    }

    func Initialize()
    {
        
        let iconImageWidth = Sizing.HundredRelativeWidthPts()
        let tabWidth = (Sizing.ScreenWidth() - iconImageWidth)/4
        let tabHeight = Sizing.HundredRelativeHeightPts()/3
        let headerHeight = Sizing.HundredRelativeHeightPts()*2
        let mainViewWidth = Sizing.ScreenWidth()
        let mainViewHeight = Sizing.ScreenHeight() - headerHeight - 49/*tab bar*/
        
        barIconImageView = UIImageView.init(frame: CGRectMake(Sizing.ScreenWidth()/2 - iconImageWidth/2, (headerHeight-iconImageWidth), iconImageWidth, iconImageWidth))
        tab1 = UIButton.init(frame: CGRectMake(0, (headerHeight-tabHeight), tabWidth, tabHeight))
        tab2 = UIButton.init(frame: CGRectMake(tabWidth, (headerHeight-tabHeight), tabWidth, tabHeight))
        tab3 = UIButton.init(frame: CGRectMake(Sizing.ScreenWidth() - (tabWidth*2), (headerHeight-tabHeight), tabWidth, tabHeight))
        tab4 = UIButton.init(frame: CGRectMake(Sizing.ScreenWidth() - tabWidth, (headerHeight-tabHeight), tabWidth, tabHeight))
        mainDetailView = UIView.init(frame: CGRectMake(0, headerHeight, mainViewWidth, mainViewHeight))
        
        self.backgroundColor = UIColor.clearColor()
        barIconImageView.backgroundColor = UIColor.grayColor()
        tab1.backgroundColor = UIColor.brownColor()
        tab2.backgroundColor = UIColor.redColor()
        tab3.backgroundColor = UIColor.yellowColor()
        tab4.backgroundColor = UIColor.blueColor()
        mainDetailView.backgroundColor = UIColor.lightGrayColor()
        
        self.addSubview(barIconImageView)
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab3)
        self.addSubview(tab4)
        self.addSubview(mainDetailView)
        
        
    }
    
    func InjectData(bar:Bar)
    {
        barIconImageView.image = bar.icon
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
