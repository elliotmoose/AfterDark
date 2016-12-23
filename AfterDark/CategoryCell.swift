//
//  CategoryCell.swift
//  
//
//  Created by Swee Har Ng on 29/10/16.
//
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var blurrView: UIVisualEffectView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.orange
        //self.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth() - Sizing.HundredRelativeWidthPts()/4, height: Sizing.HundredRelativeHeightPts()*2)
        
        self.categoryImageView.contentMode = .scaleAspectFill
        
        
        blurrView.layer.cornerRadius = 35/2
        blurrView.clipsToBounds = true
    }

    
    func SetContent(_ category : Category)
    {
        self.categoryTitleLabel.text = category.name
        self.descriptionLabel.text = "\(category.barIDs.count) Bars"
        self.categoryImageView.image = category.imageView?.image
    }
}
