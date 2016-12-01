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
        
        starLayerImage = UIImageView(image: UIImage(named: "Rating-star")?.withRenderingMode(.alwaysTemplate))
        starColorLayer = UIView(frame: frame)
        super.init(frame: frame)

        starLayerImage.tintColor = ColorManager.reviewCellBGColor
        starColorLayer.backgroundColor = ColorManager.ratingStarColor
        self.backgroundColor = ColorManager.ratingStarBGColor
        
        self.frame = frame
        SetSizeFromHeight(frame.size.height)
        
        self.addSubview(starColorLayer)
        self.addSubview(starLayerImage)
        //load background progress bar
        
    }

    func SetSizeFromWidth( _ width: CGFloat)
    {
        let widthToHeightRatio = starLayerImage.image!.size.width/starLayerImage.image!.size.height
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y,width: width , height: width/widthToHeightRatio)
                //set subview frames
        starColorLayer.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
        starLayerImage.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
    }
    
    func SetSizeFromHeight( _ height: CGFloat)
    {
        let widthToHeightRatio = starLayerImage.image!.size.width/starLayerImage.image!.size.height
        
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y,width: height*widthToHeightRatio , height: height)
        
        //set subview frames
        starColorLayer.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
        starLayerImage.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
        
    }
    
    func SetSizeFromWidthWithRating( _ width: CGFloat, _ rating : Float)
    {
        let widthToHeightRatio = starLayerImage.image!.size.width/starLayerImage.image!.size.height
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y,width: width , height: width/widthToHeightRatio)
        //set subview frames
        starColorLayer.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
        starLayerImage.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
        
        SetRating(rating)
    }
    
    func SetSizeFromHeightWithRating( _ height: CGFloat, _ rating : Float)
    {
        let widthToHeightRatio = starLayerImage.image!.size.width/starLayerImage.image!.size.height
        
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y,width: height*widthToHeightRatio , height: height)
        
        //set subview frames
        starColorLayer.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
        starLayerImage.frame = CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.size.height)
   
        SetRating(rating)

    }
    
    func SetOrigin (_ origin: CGPoint)
    {
        self.frame = CGRect(x: origin.x, y: origin.y, width: self.frame.size.width, height: self.frame.size.height)
    }
    func SetRating(_ rating : Float)
    {
        starColorLayer.frame = CGRect(x: 0 , y: 0, width: CGFloat(rating/5) * self.frame.width, height: self.frame.size.height)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
