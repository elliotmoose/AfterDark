//
//  OpeningHoursCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 4/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class OpeningHoursCell: UITableViewCell {

    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var Detail: UILabel!
    @IBOutlet weak var Arrow: UIImageView!
    
    @IBOutlet var dayLabels: [UILabel]!
    @IBOutlet var timingLabels: [UILabel]!

    //opening hours
    var openClosingHours = [String]()
    
    
    
    var isExpanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selectionStyle = .none
        
        //colors
        self.backgroundColor = ColorManager.descriptionCellBGColor
        self.Detail.textColor = ColorManager.descriptionCellTextColor
        
        //icon
        self.Icon?.image = UIImage(named: "Clock-48")?.withRenderingMode(.alwaysTemplate)
        self.Icon?.tintColor = ColorManager.descriptionIconsTintColor

        //arrow
        self.Arrow.image? =  (self.Arrow.image?.withRenderingMode(.alwaysTemplate))!
        self.Arrow.tintColor = UIColor.white
        self.Arrow.transform = CGAffineTransform(rotationAngle: 0.01); //start state

        //change alphas of labels to set to collapsed
        for label in self.dayLabels
        {
            label.alpha = 0
        }
        
        for label in self.timingLabels
        {
            label.alpha = 0
        }
    }

    
    func ExpandCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.Arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); //rotation in radians
            

            //change alphas
            for label in self.dayLabels
            {
                label.alpha = 1
            }
            
            for label in self.timingLabels
            {
                label.alpha = 1
            }
        })
    }
    
    func CollapseCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.Arrow.transform = CGAffineTransform(rotationAngle: 0.01); //rotation in radians
            
            //change alphas
            for label in self.dayLabels
            {
                label.alpha = 0
            }
            
            for label in self.timingLabels
            {
                label.alpha = 0
            }
        })
    }
    
    func LoadOpeningHours(openingHours : [String])
    {
        self.openClosingHours = openingHours
        
        for label in timingLabels
        {
            let index = timingLabels.index(of: label)
            
            guard index != nil && index! < timingLabels.count else
            {
                return
            }
            
            label.text = openingHours[index!]
        }
    }
    
}
