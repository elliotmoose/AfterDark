//
//  RatingStarView.swift
//  AfterDark
//
//  Created by Swee Har Ng on 27/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class RatingStarView: UIView {

    var starLayerImage : UIImageView
    var starColorLayer : UIView
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        
        //load 5 star image
        
        starLayerImage = UIImageView(image: UIImage(named: "Rating-star")?.imageWithRenderingMode(.AlwaysTemplate))
        starColorLayer = UIView(frame: frame)
        super.init(frame: frame)

        starLayerImage.tintColor = ColorManager.reviewCellBGColor
        starColorLayer.backgroundColor = ColorManager.ratingStarColor
        self.backgroundColor = ColorManager.ratingStarBGColor
        
        self.frame = frame
        SetSizeFromWidth(frame.size.width)
        
        self.addSubview(starColorLayer)
        self.addSubview(starLayerImage)
        //load background progress bar
        
    }

    func SetSizeFromWidth( width: CGFloat)
    {
        let widthToHeightRatio = starLayerImage.image!.size.width/starLayerImage.image!.size.height
        self.frame = CGRectMake(frame.origin.x, frame.origin.y,width , width/widthToHeightRatio)
        
        //set subview frames
        starColorLayer.frame = CGRectMake(0 , 0, self.frame.width, self.frame.size.height)
        starLayerImage.frame = CGRectMake(0 , 0, self.frame.width, self.frame.size.height)
    }
    
    func SetSizeFromHeight( height: CGFloat)
    {
        let widthToHeightRatio = starLayerImage.image!.size.width/starLayerImage.image!.size.height
        self.frame = CGRectMake(frame.origin.x, frame.origin.y,height*widthToHeightRatio , height)
        
        //set subview frames
        starColorLayer.frame = CGRectMake(0 , 0, self.frame.width, self.frame.size.height)
        starLayerImage.frame = CGRectMake(0 , 0, self.frame.width, self.frame.size.height)
    }
    
    func SetOrigin (origin: CGPoint)
    {
        self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height)
    }
    func SetRating(rating : Float)
    {
        starColorLayer.frame = CGRectMake(0 , 0, CGFloat(rating/5) * self.frame.width, self.frame.size.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
