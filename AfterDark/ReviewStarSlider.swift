//
//  ReviewStarSlider.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 9/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol AddReviewDelegate : class
{
    func ratingUpdated(slider: ReviewStarSlider)
}

class ReviewStarSlider: UISlider {

    var ratingStarView : RatingStarView?
    var currentRating : Float = 0
    weak var delegate : AddReviewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MakeUISliderTransparent()
        AddGestures()
        AddRatingStarView()
        


    }
    
    //set rect for slider
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: bounds.size.height))
        
        super.trackRect(forBounds: customBounds)
        
        return customBounds
    }
    
    func MakeUISliderTransparent()
    {
        //remove thumb image
        self.setThumbImage(UIImage(), for: .normal)
        
        self.maximumTrackTintColor = UIColor.clear
        self.minimumTrackTintColor = UIColor.clear
        
    }
    
    func SetStarLayerColor(color : UIColor)
    {
        ratingStarView?.starLayerImage.tintColor = color
    }
    
    func AddGestures()
    {
        //tap gesture
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(SliderChangeValue(_:)))
        //drag gesture
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(SliderChangeValue(_:)))
        gesture.minimumPressDuration = 0
        self.addGestureRecognizer(gesture)
        self.addGestureRecognizer(dragGesture)
    }
    

    
    func AddRatingStarView()
    {
        ratingStarView = RatingStarView(frame: .zero)
        
        if let ratingStarView = ratingStarView
        {
           
            self.addSubview(ratingStarView)
        }
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ratingStarView?.SetSizeFromWidthWithRating(self.bounds.width, currentRating)
    }
    func SliderChangeValue( _ gr : UIGestureRecognizer)
    {
        let slider = gr.view as! UISlider;
        if slider.isHighlighted
        {
            return // tap on thumb, let slider deal with it
        }
        
        let pt = gr.location(in: slider)
        let percentage = pt.x / slider.bounds.size.width;
        
        //let percentage clip to values
        let numberOfValues : Float = 5 //5 stars and 0 star = 6 values
        let clipIntermediate = ceilf(Float(percentage) * numberOfValues)
        var clippedPercentage = clipIntermediate/numberOfValues
        
        //limit max
        if clippedPercentage > 1
        {
            clippedPercentage = 1
        }
        
        //limit min
        if clippedPercentage < 0
        {
            clippedPercentage = 0
        }
        
        let delta = Float(clippedPercentage) * Float(slider.maximumValue - slider.minimumValue);
        let value = Float(slider.minimumValue) + Float(delta);
        slider.setValue(value, animated: true)
        
        if let ratingStarView = ratingStarView
        {
            ratingStarView.SetRating(value * 5)
        }
        
        //this variable is to coordinate when view did layout subviews
        currentRating = value * 5
        
        //send delegate
        self.delegate?.ratingUpdated(slider: self)
        
    }

    func SetRating(rating : Float)
    {
        ratingStarView?.SetRating(rating)
        currentRating = rating
    }
}
