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
    
    @IBOutlet weak var ReviewByLabel: UILabel!
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

        collapseIndicator.image = collapseIndicator.image?.withRenderingMode(.alwaysTemplate)
        collapseIndicator.tintColor = ColorManager.expandArrowColor
        
        self.clipsToBounds = true
        self.selectionStyle = .none
        
        self.ReviewTitleLabel.textColor = ColorManager.reviewTitleColor
        self.ReviewBodyLabel.textColor = ColorManager.reviewTitleColor
        self.ReviewByLabel.textColor = ColorManager.reviewTitleColor
        self.backgroundColor = ColorManager.reviewCellBGColor
        ReviewBodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        ReviewBodyLabel.numberOfLines = 0
        
        //for height of cell
        self.textLabel?.textColor = UIColor.clear
        self.textLabel?.backgroundColor = UIColor.clear
        self.textLabel?.numberOfLines = 0
        
        let distanceFromLeft : CGFloat = 10
        let avgRatingStarYCoord = (self.textLabel?.frame.size.height)! + (self.textLabel?.frame.origin.y)!
        let starLabelWidth = Sizing.HundredRelativeWidthPts()*1
        let starsXCoord = distanceFromLeft + starLabelWidth
        let starHeight = Sizing.HundredRelativeHeightPts()*0.2
        let gap : CGFloat = 3
        
        //by default the frame follows the height set, hence we can set width as 0
        avgStarsLabel = UILabel(frame: CGRect(x: distanceFromLeft,y: avgRatingStarYCoord,width: starLabelWidth,height: starHeight))
        priceStarsLabel = UILabel(frame: CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap),width: starLabelWidth,height: starHeight))
        ambienceStarsLabel = UILabel(frame: CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap) * 2,width: starLabelWidth,height: starHeight))
        serviceStarsLabel = UILabel(frame: CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap) * 3,width: starLabelWidth,height: starHeight))
        foodStarsLabel = UILabel(frame: CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap) * 4,width: starLabelWidth,height: starHeight))
        
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
        
        avgRatingStars = RatingStarView(frame: CGRect(x: starsXCoord,y: avgRatingStarYCoord,width: 0,height: starHeight))
        priceRatingStars = RatingStarView(frame: CGRect(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap),width: 0,height: starHeight))
        ambienceRatingStars = RatingStarView(frame: CGRect(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap) * 2,width: 0,height: starHeight))
        serviceRatingStars = RatingStarView(frame: CGRect(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap) * 3,width: 0,height: starHeight))
        foodRatingStars = RatingStarView(frame: CGRect(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap) * 4,width: 0,height: starHeight))

        collapseIndicator.frame = CGRect(x: starsXCoord + (avgStarsLabel?.frame.size.width)! + 10, y: avgRatingStarYCoord, width: 20, height: 20)
        collapseIndicator.center = CGPoint(x: collapseIndicator.center.x, y: (avgRatingStars?.center.y)!)

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


    
    func SetContent(_ title: String,body: String,avgRating : Float,priceRating: Float, ambienceRating: Float,serviceRating: Float, foodRating: Float, username : String)
    {

        ReviewTitleLabel.text = title
        ReviewBodyLabel.text = body
        ReviewByLabel.text = "Review by: \(username)"
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
        avgRatingStars?.SetOrigin(CGPoint(x: starsXCoord,y: avgRatingStarYCoord))
        priceRatingStars?.SetOrigin(CGPoint(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap)))
        ambienceRatingStars?.SetOrigin(CGPoint(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap) * 2))
        serviceRatingStars?.SetOrigin(CGPoint(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap) * 3))
        foodRatingStars?.SetOrigin(CGPoint(x: starsXCoord,y: avgRatingStarYCoord + (starHeight + gap) * 4))

        //by default the frame follows the height set, hence we can set width as 0
        avgStarsLabel?.frame = CGRect(x: distanceFromLeft,y: avgRatingStarYCoord,width: starLabelWidth,height: starHeight)
        priceStarsLabel?.frame = CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap),width: starLabelWidth,height: starHeight)
        ambienceStarsLabel?.frame = CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap) * 2,width: starLabelWidth,height: starHeight)
        serviceStarsLabel?.frame = CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap) * 3,width: starLabelWidth,height: starHeight)
        foodStarsLabel?.frame = CGRect(x: distanceFromLeft,y: avgRatingStarYCoord + (starHeight + gap) * 4,width: starLabelWidth,height: starHeight)
        
        collapseIndicator.frame = CGRect(x: starsXCoord + (avgStarsLabel?.frame.size.width)! + 20, y: avgRatingStarYCoord, width: 20, height: 20)
        collapseIndicator.center = CGPoint(x: collapseIndicator.center.x, y: (avgRatingStars?.center.y)!)

        self.CollapseCell()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ExpandCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.priceRatingStars?.alpha = 1
            self.ambienceRatingStars?.alpha = 1
            self.serviceRatingStars?.alpha = 1
            self.foodRatingStars?.alpha = 1
            self.priceStarsLabel?.alpha = 1
            self.ambienceStarsLabel?.alpha = 1
            self.serviceStarsLabel?.alpha = 1
            self.foodStarsLabel?.alpha = 1
            
            self.collapseIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); //rotation in radians

        })
    }
    
    func CollapseCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.priceRatingStars?.alpha = 0
            self.ambienceRatingStars?.alpha = 0
            self.serviceRatingStars?.alpha = 0
            self.foodRatingStars?.alpha = 0
            self.priceStarsLabel?.alpha = 0
            self.ambienceStarsLabel?.alpha = 0
            self.serviceStarsLabel?.alpha = 0
            self.foodStarsLabel?.alpha = 0
        self.collapseIndicator.transform = CGAffineTransform(rotationAngle: 0.01); //rotation in radians

        })
    }
    
}
extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
