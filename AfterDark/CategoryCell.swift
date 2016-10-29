//
//  CategoryCell.swift
//  
//
//  Created by Swee Har Ng on 29/10/16.
//
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.orangeColor()
        self.frame = CGRectMake(0, 0, Sizing.ScreenWidth(), Sizing.HundredRelativeHeightPts()*2)
    }

    
    func SetContent(category : Category)
    {
        self.categoryTitleLabel.text = category.name
        self.descriptionLabel.text = "\(category.barIDs.count) Bars"
    }
}
