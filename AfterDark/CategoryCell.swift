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
        
        self.backgroundColor = ColorManager.darkGray
        //self.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth() - Sizing.HundredRelativeWidthPts()/4, height: Sizing.HundredRelativeHeightPts()*2)
        
        self.categoryImageView.contentMode = .scaleAspectFill
        
        //fonts
//        self.categoryTitleLabel.font = UIFont(name: "Mohave-Bold", size: 40)
//        self.descriptionLabel.font = UIFont(name: "champagne-limousines", size: 12)
    }

    
    func SetContent(_ category : Category)
    {
        self.categoryTitleLabel.text = category.name
        self.descriptionLabel.text = "\(category.description)"
        self.categoryImageView.image = category.imageView?.image
    }
    
    
}
