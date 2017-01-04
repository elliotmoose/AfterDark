//
//  CategoryTableCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps
class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var barNameLabel: UILabel!
    
    @IBOutlet weak var ratingStarContainerView: UIView!
    
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var overlayView: UIView!
    
    let ratingStarView = RatingStarView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.ratingStarContainerView.addSubview(ratingStarView)
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func SetContent(bar : Bar)
    {
        
        //set name, rating, number of ratings,tags,distance, time taken to travel, cost
        self.barNameLabel.text = bar.name
        ratingStarView.SetSizeFromWidth(ratingStarContainerView.bounds.width)
        ratingStarView.SetRating(bar.rating.avg)
        
        ratingCountLabel.text = "(\(bar.totalReviewCount) Ratings)"
        
        //get time and distance from current location
        let locationManager = CLLocationManager()
        let myLocation = locationManager.location?.coordinate
        print(myLocation)
        
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(myLocation!.latitude),\(myLocation!.longitude)&destinations=\(bar.loc_lat),\(bar.loc_long)"
        Network.singleton.DataFromUrl(url, handler:
        {
            (success,output) -> Void in
//            
//            let outString = String(data: output!, encoding: .utf8)!
//            print(outString)
//            
//            if success
//            {
//                do
//                {
//                    if let dict = try JSONSerialization.jsonObject(with: output!, options: .allowFragments) as? NSDictionary
//                    {
//                        if let destArr = dict["destination_addresses"] as? NSArray
//                        {
//                            for dest in destArr
//                            {
//                                print(dest)
//                            }
//                        }
//                    }
//                }
//                catch let error as NSError
//                {
//                    
//                }
//
//            }
        })
    }
    
    func DimCell()
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.overlayView.alpha = 0.8
        })
        
    }
    
    func UnDimCell()
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.overlayView.alpha = 0
        })
    }
    
    
}
