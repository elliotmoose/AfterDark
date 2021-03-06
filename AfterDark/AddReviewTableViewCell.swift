//
//  AddReviewTableViewCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 9/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol AddReviewDelegate : class {
    func ratingUpdated(slider : ReviewStarSlider)
}


class AddReviewTableViewCell: UITableViewCell,AddDetailReviewDelegate,AddReviewDelegate{
    internal func ratingUpdated(slider: ReviewStarSlider) {
        avgLabel.text = "\(avgSlider.currentRating)"
    }

    
    
    @IBOutlet weak var avgSlider: ReviewStarSlider!
    
    @IBOutlet weak var avgLabel: UILabel!

    @IBOutlet weak var submitReviewButton: UIButton!
    
    var isExpanded : Bool = false
    
    weak var delegate : AddReviewCellDelegate?
    
    @IBAction func writeReviewButtonPressed(_ sender: Any) {
        self.delegate?.ShowAddDetailReviewController()
        AddDetailedReviewViewController.singleton.avgSlider.SetRating(rating: avgSlider.currentRating)
        AddDetailedReviewViewController.singleton.ratingUpdated(slider: AddDetailedReviewViewController.singleton.avgSlider)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        avgSlider.delegate = self
        AddDetailedReviewViewController.singleton.delegate = self

        //ui
        //shadows
        submitReviewButton.layer.shadowOpacity = 1;
        submitReviewButton.layer.shadowColor = UIColor.darkGray.cgColor
        submitReviewButton.layer.shadowOffset = CGSize(width: 1.5, height: 2)
        submitReviewButton.layer.shadowRadius = 0
        submitReviewButton.clipsToBounds = false
        submitReviewButton.layer.cornerRadius = 6
    }


    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func DismissAddDetailReviewView() {
        self.delegate?.HideAddDetailReviewController()
    }
    
    func UpdateReviewTable()
    {
        self.delegate?.ReloadReviewTableData()
    }
}
