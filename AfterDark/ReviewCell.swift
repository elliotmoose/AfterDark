//
//  ReviewCell.swift
//  AfterDark
//
//  Created by Swee Har Ng on 25/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//
import Foundation
import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var ReviewTitleLabel: UILabel!
    @IBOutlet weak var ReviewBodyLabel: UILabel!
    
    //rating stars display
    var avgRatingStars : RatingStarView?
    var priceRatingStars : RatingStarView?
    var ambienceRatingStars : RatingStarView?
    var serviceRatingStars : RatingStarView?
    var foodRatingStars : RatingStarView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ReviewTitleLabel.textColor = ColorManager.reviewTitleColor
        self.ReviewBodyLabel.textColor = ColorManager.reviewTitleColor
        self.backgroundColor = ColorManager.reviewCellBGColor
        ReviewBodyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        ReviewBodyLabel.numberOfLines = 0
        
        //for height of cell
        self.textLabel?.textColor = UIColor.clearColor()
        self.textLabel?.backgroundColor = UIColor.clearColor()
        self.textLabel?.numberOfLines = 0
        
        
        //get origin.y for first star
        let avgRatingStarYCoord = (self.textLabel?.frame.size.height)! + (self.textLabel?.frame.origin.y)!
        
        //by default the frame follows the width set, hence we can set height as 0
        avgRatingStars = RatingStarView(frame: CGRectMake(5,avgRatingStarYCoord,Sizing.HundredRelativeWidthPts(),0))
        priceRatingStars = RatingStarView(frame: CGRectMake(5,(avgRatingStars?.frame.height)! + (avgRatingStars?.frame.origin.y)!,Sizing.HundredRelativeWidthPts(),0))
        ambienceRatingStars = RatingStarView(frame: CGRectMake(5,avgRatingStarYCoord,Sizing.HundredRelativeWidthPts(),0))
        serviceRatingStars = RatingStarView(frame: CGRectMake(5,avgRatingStarYCoord,Sizing.HundredRelativeWidthPts(),0))
        foodRatingStars = RatingStarView(frame: CGRectMake(5,avgRatingStarYCoord,Sizing.HundredRelativeWidthPts(),0))


        self.addSubview(avgRatingStars!)
        self.addSubview(priceRatingStars!)
        self.addSubview(ambienceRatingStars!)
        self.addSubview(serviceRatingStars!)
        self.addSubview(foodRatingStars!)
        
    }


    
    func SetContent(title: String,body: String,avgRating : Float,priceRating: Float, ambienceRating: Float,serviceRating: Float, foodRating: Float)
    {

        ReviewTitleLabel.text = title
        ReviewBodyLabel.text = body
        
        //for height
        self.textLabel?.text = body
        self.avgRatingStars?.SetRating(avgRating)
        self.priceRatingStars?.SetRating(priceRating)
        self.ambienceRatingStars?.SetRating(ambienceRating)
        self.serviceRatingStars?.SetRating(serviceRating)
        self.foodRatingStars?.SetRating(foodRating)

 
        let heightOfLabel = body.heightWithConstrainedWidth(self.ReviewBodyLabel.frame.width, font: self.ReviewBodyLabel.font)
        let avgRatingStarYCoord = heightOfLabel + (self.ReviewBodyLabel.frame.origin.y)
        
        //by default the frame follows the width set, hence we can set height as 0
        avgRatingStars?.SetOrigin(CGPointMake(5, avgRatingStarYCoord))
        priceRatingStars?.SetOrigin(CGPointMake(5, avgRatingStarYCoord + 20))
        ambienceRatingStars?.SetOrigin(CGPointMake(5, avgRatingStarYCoord + 40))
        serviceRatingStars?.SetOrigin(CGPointMake(5, avgRatingStarYCoord + 60))
        foodRatingStars?.SetOrigin(CGPointMake(5, avgRatingStarYCoord + 80))

        

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}