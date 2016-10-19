//
//  BarDetailHeaderView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 18/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarDetailViewMainCell: UITableViewCell {

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
        tab1 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab2 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab3 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        tab4 = UIButton.init(frame: CGRectMake(0, 0, 0, 0))
        mainDetailView = UIView.init(frame: CGRectMake(0, 0, 0, 0))
        super.init(coder: aDecoder)

    }

    init(frame: CGRect)
    {
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
        
        let tabWidth = Sizing.ScreenWidth()/4
        let tabHeight = Sizing.HundredRelativeHeightPts()/3
        let mainViewWidth = Sizing.ScreenWidth()
        let mainViewHeight = Sizing.ScreenHeight() - Sizing.HundredRelativeHeightPts()*2/*gallery min height*/ - 49/*tab bar*/
        //status bar height?
        tab1 = UIButton.init(frame: CGRectMake(0, 0, tabWidth, tabHeight))
        tab2 = UIButton.init(frame: CGRectMake(tabWidth, 0, tabWidth, tabHeight))
        tab3 = UIButton.init(frame: CGRectMake(Sizing.ScreenWidth() - (tabWidth*2), 0, tabWidth, tabHeight))
        tab4 = UIButton.init(frame: CGRectMake(Sizing.ScreenWidth() - tabWidth, 0, tabWidth, tabHeight))
        mainDetailView = UIView.init(frame: CGRectMake(0, tabHeight, mainViewWidth, mainViewHeight))
        
        self.backgroundColor = UIColor.clearColor()
        tab1.backgroundColor = UIColor.brownColor()
        tab2.backgroundColor = UIColor.redColor()
        tab3.backgroundColor = UIColor.yellowColor()
        tab4.backgroundColor = UIColor.blueColor()
        mainDetailView.backgroundColor = UIColor.lightGrayColor()
        
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab3)
        self.addSubview(tab4)
        self.addSubview(mainDetailView)
        
        
    }
    
    func InjectData(bar:Bar)
    {
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
