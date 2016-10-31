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
        
        self.backgroundColor = UIColor.orange
        self.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.HundredRelativeHeightPts()*2)
    }

    
    func SetContent(_ category : Category)
    {
        self.categoryTitleLabel.text = category.name
        self.descriptionLabel.text = "\(category.bars.count) Bars"
    }
}
