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
    
    var isExpanded = false
    
    //rating stars display
    var avgStarsLabel : UILabel?
    var priceStarsLabel : UILabel?
    var ambienceStarsLabel : UILabel?
    var serviceStarsLabel : UILabel?
    var foodStarsLabel : UILabel?
    

    var avgRatingStars : RatingStarView?
    var priceRatingStars : RatingStarView?
    var ambienceRatingStars : RatingStarView?
    var serviceRatingStars : RatingStarView?
    var foodRatingStars : RatingStarView?
    
    var collapseIndicator = UIImageView(image: UIImage(named: "arrow"))
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collapseIndicator.image = collapseIndicator.image?.imageWithRenderingMode(.AlwaysTemplate)
        collapseIndicator.tintColor = ColorManager.expandArrowColor
        
        self.clipsToBounds = true
        self.selectionStyle = .None
        
        self.ReviewTitleLabel.textColor = ColorManager.reviewTitleColor
        self.ReviewBodyLabel.textColor = ColorManager.reviewTitleColor
        self.backgroundColor = ColorManager.reviewCellBGColor
        ReviewBodyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        ReviewBodyLabel.numberOfLines = 0
        
        //for height of cell
        self.textLabel?.textColor = UIColor.clearColor()
        self.textLabel?.backgroundColor = UIColor.clearColor()
        self.textLabel?.numberOfLines = 0
        
        let distanceFromLeft : CGFloat = 10
        let avgRatingStarYCoord = (self.textLabel?.frame.size.height)! + (self.textLabel?.frame.origin.y)!
        let starLabelWidth = Sizing.HundredRelativeWidthPts()*1
        let starsXCoord = distanceFromLeft + starLabelWidth
        let starHeight = Sizing.HundredRelativeHeightPts()*0.2
        let gap : CGFloat = 3
        
        //by default the frame follows the height set, hence we can set width as 0
        avgStarsLabel = UILabel(frame: CGRectMake(distanceFromLeft,avgRatingStarYCoord,starLabelWidth,starHeight))
        priceStarsLabel = UILabel(frame: CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap),starLabelWidth,starHeight))
        ambienceStarsLabel = UILabel(frame: CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap) * 2,starLabelWidth,starHeight))
        serviceStarsLabel = UILabel(frame: CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap) * 3,starLabelWidth,starHeight))
        foodStarsLabel = UILabel(frame: CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap) * 4,starLabelWidth,starHeight))
        
        avgStarsLabel!.text = "Average:"
        priceStarsLabel!.text = "Pricing:"
        ambienceStarsLabel!.text = "Ambience:"
        serviceStarsLabel!.text = "Service:"
        foodStarsLabel!.text = "Food:"
        
        avgStarsLabel!.textColor = ColorManager.ratingStarLabelTextColor
        priceStarsLabel!.textColor = ColorManager.ratingStarLabelTextColor
        ambienceStarsLabel!.textColor = ColorManager.ratingStarLabelTextColor
        serviceStarsLabel!.textColor = ColorManager.ratingStarLabelTextColor
        foodStarsLabel!.textColor = ColorManager.ratingStarLabelTextColor
        
        avgRatingStars = RatingStarView(frame: CGRectMake(starsXCoord,avgRatingStarYCoord,0,starHeight))
        priceRatingStars = RatingStarView(frame: CGRectMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap),0,starHeight))
        ambienceRatingStars = RatingStarView(frame: CGRectMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap) * 2,0,starHeight))
        serviceRatingStars = RatingStarView(frame: CGRectMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap) * 3,0,starHeight))
        foodRatingStars = RatingStarView(frame: CGRectMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap) * 4,0,starHeight))

        collapseIndicator.frame = CGRectMake(starsXCoord + (avgStarsLabel?.frame.size.width)! + 5, avgRatingStarYCoord, 20, 20)

        self.addSubview(avgRatingStars!)
        self.addSubview(priceRatingStars!)
        self.addSubview(ambienceRatingStars!)
        self.addSubview(serviceRatingStars!)
        self.addSubview(foodRatingStars!)
        
        self.addSubview(avgStarsLabel!)
        self.addSubview(priceStarsLabel!)
        self.addSubview(ambienceStarsLabel!)
        self.addSubview(serviceStarsLabel!)
        self.addSubview(foodStarsLabel!)
        
        self.addSubview(collapseIndicator)
        
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

 
        let offset = Sizing.HundredRelativeHeightPts()*0.25
        let heightOfLabel = body.heightWithConstrainedWidth(self.ReviewBodyLabel.frame.width, font: self.ReviewBodyLabel.font)
        let avgRatingStarYCoord = heightOfLabel + (self.ReviewBodyLabel.frame.origin.y) + offset
        
        let distanceFromLeft : CGFloat = 10
        let starLabelWidth = Sizing.HundredRelativeWidthPts()*1
        let starsXCoord = distanceFromLeft + starLabelWidth
        let starHeight = Sizing.HundredRelativeHeightPts()*0.2
        let gap : CGFloat = 3
        
        //by default the frame follows the width set, hence we can set height as 0
        avgRatingStars?.SetOrigin(CGPointMake(starsXCoord,avgRatingStarYCoord))
        priceRatingStars?.SetOrigin(CGPointMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap)))
        ambienceRatingStars?.SetOrigin(CGPointMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap) * 2))
        serviceRatingStars?.SetOrigin(CGPointMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap) * 3))
        foodRatingStars?.SetOrigin(CGPointMake(starsXCoord,avgRatingStarYCoord + (starHeight + gap) * 4))

        //by default the frame follows the height set, hence we can set width as 0
        avgStarsLabel?.frame = CGRectMake(distanceFromLeft,avgRatingStarYCoord,starLabelWidth,starHeight)
        priceStarsLabel?.frame = CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap),starLabelWidth,starHeight)
        ambienceStarsLabel?.frame = CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap) * 2,starLabelWidth,starHeight)
        serviceStarsLabel?.frame = CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap) * 3,starLabelWidth,starHeight)
        foodStarsLabel?.frame = CGRectMake(distanceFromLeft,avgRatingStarYCoord + (starHeight + gap) * 4,starLabelWidth,starHeight)
        
        collapseIndicator.frame = CGRectMake(starsXCoord + (avgStarsLabel?.frame.size.width)! + 5, avgRatingStarYCoord, 20, 20)

        self.CollapseCell()

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ExpandCell()
    {
        UIView.animateWithDuration(0.5, animations: {
            self.priceRatingStars?.alpha = 1
            self.ambienceRatingStars?.alpha = 1
            self.serviceRatingStars?.alpha = 1
            self.foodRatingStars?.alpha = 1
            self.priceStarsLabel?.alpha = 1
            self.ambienceStarsLabel?.alpha = 1
            self.serviceStarsLabel?.alpha = 1
            self.foodStarsLabel?.alpha = 1
            
            self.collapseIndicator.transform = CGAffineTransformMakeRotation(CGFloat(M_PI)); //rotation in radians

        })
    }
    
    func CollapseCell()
    {
        UIView.animateWithDuration(0.5, animations: {
            self.priceRatingStars?.alpha = 0
            self.ambienceRatingStars?.alpha = 0
            self.serviceRatingStars?.alpha = 0
            self.foodRatingStars?.alpha = 0
            self.priceStarsLabel?.alpha = 0
            self.ambienceStarsLabel?.alpha = 0
            self.serviceStarsLabel?.alpha = 0
            self.foodStarsLabel?.alpha = 0
        self.collapseIndicator.transform = CGAffineTransformMakeRotation(0.01); //rotation in radians

        })
    }
    
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}